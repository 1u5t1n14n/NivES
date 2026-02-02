{ host, config, lib, ... }:

{

	services = {
		nginx.virtualHosts."anki.is.internal" = lib.mkIf config.services.anki-sync-server.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://${config.services.anki-sync-server.address}:${toString config.services.anki-sync-server.port}";
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.anki-sync-server.enable
			[ "192.168.178.185 anki.is.internal" ];

		anki-sync-server = {
			address = "127.0.0.1";
			port = 27701;

			users = [
				{
					username = host.user;
					passwordFile = config.sops.secrets."services/anki/root".path;
				}
				{
					username = "nathan";
					passwordFile = config.sops.secrets."services/anki/nathan".path;
				}
			];
		};
	};

	sops.secrets = {
		"services/anki/root" = { };
		"services/anki/nathan" = { };
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.anki-sync-server.enable [
		{
			directory = "/var/lib/private/anki-sync-server";
			mode = "0700";
		}
	];

}
