{ config, lib, ... }:

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

	networking.firewall.allowedTCPPorts = lib.mkIf config.services.nginx.enable
		[ 80 443 ];

	environment.persistence."/persist".directories = lib.mkIf config.services.postgresql.enable
		[ config.services.postgresql.dataDir ];

}
