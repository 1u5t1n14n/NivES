{ lib, config, ... }:

{

	services = {
		nginx.virtualHosts."media.is.internal" = lib.mkIf config.services.jellyfin.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://127.0.0.1:8096";
					proxyWebsockets = true;
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.jellyfin.enable
			[ "192.168.178.185 media.is.internal" ];

		jellyfin = { };
	};

}
