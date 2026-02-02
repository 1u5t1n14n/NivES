{ config, lib, ... }:

{

	services = {
		nginx.virtualHosts."git.is.internal" = lib.mkIf config.services.gitea.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.gitea.enable
			[ "192.168.178.185 git.is.internal" ];

		gitea = {
			settings = {
				server = {
					PROTOCOL = "http";
					HTTP_ADDR = "127.0.0.1";
					HTTP_PORT = 8880;
				};

				service = {
					DISABLE_REGISTRATION = true;
				};

				session = {
					COOKIE_SECURE = false;
				};
			};
		};
	};

}
