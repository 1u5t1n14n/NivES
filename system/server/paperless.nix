{ config, pkgs, lib, ... }:

{

	services = {
		nginx.virtualHosts."less.is.internal" = lib.mkIf config.services.paperless.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
					proxyWebsockets = true;
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.paperless.enable
			[ "192.168.178.185 less.is.internal" ];

		paperless = {
			address = "127.0.0.1";
			port = 28981;

			consumptionDir = "${config.services.paperless.dataDir}/consume";
			consumptionDirIsPublic = true;
			passwordFile = config.sops.secrets."services/paperless/root".path;

			settings = {
				PAPERLESS_APP_TITLE = "Less Is Internal";
				PAPERLESS_ADMIN_USER = config.services.nextcloud.config.adminuser;
				PAPERLESS_OCR_LANGUAGE = "deu+eng";
				PAPERLESS_OCR_USER_ARGS = {
					optimize = 1;
					pdfa_image_compression = "lossless";
				};
				PAPERLESS_EMPTY_TRASH_DELAY = 15;
				PAPERLESS_TIKA_ENABLED = true;
				PAPERLESS_GOTENBERG_ENABLED = true;
				PAPERLESS_TIKA_ENDPOINT = "http://${config.services.tika.listenAddress}:${toString config.services.tika.port}";
				PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://${config.services.gotenberg.bindIP}:${toString config.services.gotenberg.port}";
			};
		};

		tika = {
			enable = config.services.paperless.settings.PAPERLESS_TIKA_ENABLED && config.services.paperless.enable;
			enableOcr = true;

			port = 9998;
		};
		gotenberg = {
			enable = config.services.paperless.settings.PAPERLESS_GOTENBERG_ENABLED && config.services.paperless.enable;

			chromium = {
				package = pkgs.ungoogled-chromium;
				disableJavascript = true;
			};

			extraArgs = [ "--chromium-allow-list=file:///tmp/.*" ];
			extraFontPackages = config.fonts.packages;

			port = 3001;
		};
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.paperless.enable
		[ config.services.paperless.dataDir ];

	networking.firewall.allowedTCPPorts = lib.mkIf (config.services.paperless.enable
		&& (config.services.paperless.address == "0.0.0.0"))
		[ config.services.paperless.port ];

}
