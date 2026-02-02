{ lib, config, ... }:

{

	services = {
		nginx.virtualHosts."ntfy.is.internal" = lib.mkIf config.services.ntfy-sh.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.ntfy-sh.enable
			[ "192.168.178.185 ntfy.is.internal" ];

		ntfy-sh = {
			settings = {
				base-url = "http://ntfy.is.internal";
				listen-http = "127.0.0.1:8088";
			};
		};
	};

}
