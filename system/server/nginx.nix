{ config, ... }:

{

	services.nginx = {
		recommendedGzipSettings = true;
		recommendedOptimisation = true;
		recommendedProxySettings = true;

		enable = (
			config.services.nextcloud.enable
			|| config.services.paperless.enable
			|| config.services.pihole-ft.enable
			|| config.services.anki-sync-server.enable
			|| config.services.opencloud.enable
			|| config.services.gitea.enable
			|| config.services.ntfy-sh.enable
			|| config.services.immich.enable
			|| config.services.homepage-dashboard.enable
		);
	};

}
