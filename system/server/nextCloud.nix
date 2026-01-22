{ config, host, pkgs, lib, ... }:

let
	occ = "${config.services.nextcloud.occ}/bin/nextcloud-occ";

	secretKey = "diesisteinsecretkey";

in
{

	# TODO: Secret Management

	services = {
		nextcloud = {
			hostName = "localhost";

			package = pkgs.nextcloud32;

			# Set Theming URL
			extraOCC = lib.mkIf false
				''
					${occ} theming:config url "${
						if config.services.nextcloud.https then
							"https"
						else "http"}://${
						if (config.services.nextcloud.hostName != "localhost") then
							config.services.nextcloud.hostName
						else lib.toLower host.name}"

					${occ} app:disable photos
					${occ} app:disable dashboard
				'';

			configureRedis = true;
			phpOptions."opcache.interned_strings_buffer" = 16;
			nginx.hstsMaxAge = 15552000;

			# App Installation
			appstoreEnable = false;
			extraAppsEnable = true;
			autoUpdateApps.enable = config.services.nextcloud.extraAppsEnable;

			# TODO: Add `maps` once it's packaged for NextCloud 32
			extraApps = {
				inherit (config.services.nextcloud.package.packages.apps) calendar contacts news memories;
			};

			database.createLocally = true;
			config = {
				dbtype = "pgsql";
				dbuser = "nextcloud";
				adminuser = "root";
				adminpassFile = # config.sops.secrets."services/nextcloud/main".path;
			};

			maxUploadSize = "1G";

			settings = {
				maintenance_window_start = 1;
				updatechecker = false;

				preview_libreoffice_path = "${pkgs.libreoffice-fresh}/bin/libreoffice";
				preview_ffmpeg_path = "${pkgs.ffmpeg-full}/bin/ffmpeg";

				# Should be 1 if Changing should happen
				filesystem_check_changes = 0;
				quota_include_external_storage = true;

				defaultapp = "files";
				"simpleSignUpLink.shown" = false;
				login_form_autocomplete = false;

				default_phone_region = "DE";
				default_language = "de_DE";
				default_locale = "de";
				default_timezone = config.time.timeZone;

				reduce_to_languages = [ "de" "de_DE" "en" ];

				trusted_domains = [
					config.services.nextcloud.hostName
					"192.168.178.178"
					host.name
				];
			};

			config.objectstore.s3 = {
				enable = true;
				bucket = "nextcloud";
				verify_bucket_exists = true;
				key = accessKey;
				secretFile = "/etc/${config.environment.etc.nextcloud.target}";
				hostname = "localhost";
				useSsl = false;
				port = 9000;
				usePathStyle = true;
				region = "us-east-1";
			};
		};

		minio = {
			enable = (config.services.nextcloud.config.objectstore.s3.enable
				&& config.services.nextcloud.enable);
			listenAddress = "127.0.0.1:${toString config.services.nextcloud.config.objectstore.s3.port}";
			consoleAddress = "127.0.0.1:9001";
			rootCredentialsFile = "/etc/${config.environment.etc.minio.target}";

			# Only listens on localhost.
			browser = false;
		};
	};

	systemd.services = {
		minioSetup = lib.mkIf config.services.minio.enable
			{
				path = [ pkgs.minio-client pkgs.getent ];
				script = ''
					${lib.getExe pkgs.minio-client} alias set minio http://${config.services.nextcloud.config.objectstore.s3.hostname}:${toString config.services.nextcloud.config.objectstore.s3.port} ${config.services.nextcloud.config.objectstore.s3.key} ${secretKey} --api s3v4
					${lib.getExe pkgs.minio-client} mb --ignore-existing minio/${config.services.nextcloud.config.objectstore.s3.bucket}
				'';
				serviceConfig = {
					User = config.services.nextcloud.config.dbuser;
					Group = config.users.users.${config.services.nextcloud.config.dbuser}.group;
					WorkingDirectory = config.services.nextcloud.home;

					Type = "oneshot";
					RemainAfterExit = true;

					ProtectHome = true;
					PrivateDevices = true;
					ProtectClock = true;
				};
				after = [ "minio.service" ];
				wantedBy = [ "nextcloud-setup.service" ];
			};
	};

	environment = {
		persistence."/persist".directories = lib.mkIf config.services.nextcloud.enable
			[ config.services.nextcloud.home ]

		++ lib.optionals services.minio.enable
			config.services.minio.dataDir ++ [
				config.services.minio.configDir
				config.services.minio.certificatesDir
			];
		etc = {
			minio.text = ''
				MINIO_ROOT_USER=${config.services.nextcloud.config.dbuser}
				MINIO_ROOT_PASSWORD=${secretKey}
			'';
			nextcloud.text = secretKey;
		};
	};

	networking.firewall.allowedTCPPorts = lib.mkIf config.services.nextcloud.enable
		[ 80 443 ];

}
