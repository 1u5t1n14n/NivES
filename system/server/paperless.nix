{ config, pkgs, lib, ... }:

{

	services = {
		paperless = {
			address = "0.0.0.0";
			port = 28981;

			consumptionDir = "${config.services.paperless.dataDir}/${config.services.paperless.settings.PAPERLESS_APP_TITLE}";
			consumptionDirIsPublic = true;
			passwordFile = config.sops.secrets."services/paperless/root".path;

			settings = {
				PAPERLESS_APP_TITLE = "Less Our Home";
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

	networking.firewall.allowedTCPPorts = lib.mkIf (config.services.paperless.enable && (config.services.paperless.address == "0.0.0.0"))
		[ config.services.paperless.port ];

}
