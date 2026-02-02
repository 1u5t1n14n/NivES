{ config, lib, ... }:

{

	services = {
		nginx.virtualHosts."album.is.internal" = lib.mkIf config.services.immich.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.album.enable
			[ "192.168.178.185 album.is.internal" ];

		immich = {
			port = 2283;
			host = "127.0.0.1";
		};
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.immich.enable
		[ config.services.immich.mediaLocation ];

}
