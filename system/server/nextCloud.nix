{ config, host, pkgs, lib, ... }:

{

	services = {
		nextcloud = {
			hostName = "cloud.is.internal";

			package = pkgs.nextcloud32;

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
				adminpassFile = config.sops.secrets."services/nextcloud/root".path;
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
					host.name
				];
			};

			config.objectstore.s3 = {
				enable = true;
				bucket = "nextcloud";
				verify_bucket_exists = true;
				key = "nextcloud";
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

	sops.secrets."services/nextcloud/root".owner = config.services.nextcloud.config.dbuser;

	systemd.services = lib.mkIf false {
		minioSetup = lib.mkIf config.services.minio.enable
			{
				path = [ pkgs.minio-client pkgs.getent ];
				script = ''
					${lib.getExe pkgs.minio-client} alias set minio http://${config.services.nextcloud.config.objectstore.s3.hostname}:${toString config.services.nextcloud.config.objectstore.s3.port} ${config.services.nextcloud.config.objectstore.s3.key} ${config.environment.etc.nextcloud.text} --api s3v4
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
		persistence."/persist".directories = [ ]

		++ lib.optionals config.services.nextcloud.enable
			[{
				directory = config.services.nextcloud.home;
				user = config.services.nextcloud.config.dbuser;
				group = config.users.users.${config.services.nextcloud.config.dbuser}.group;
				mode = "0700";
			}]

		++ lib.optionals config.services.minio.enable
			[{
				directory = "/var/lib/minio";
				user = config.systemd.services.minio.serviceConfig.User;
				group = config.systemd.services.minio.serviceConfig.Group;
				mode = "0700";
			}];

		etc = {
			minio.text = ''
				MINIO_ROOT_USER=${config.services.nextcloud.config.dbuser}
				MINIO_ROOT_PASSWORD=${config.environment.etc.nextcloud.text}
			'';
			nextcloud.text = "diesisteinsecretkey";
		};
	};

}
