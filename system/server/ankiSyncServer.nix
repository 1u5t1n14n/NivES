{ host, config, lib, ... }:

{

	services.anki-sync-server = {
		address = "0.0.0.0";
		port = 27701;

		openFirewall = (config.services.anki-sync-server.address == "0.0.0.0");
		baseDirectory = "/var/lib/anki";

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

	sops.secrets = {
		"services/anki/root" = { };
		"services/anki/nathan" = { };
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.anki-sync-server.enable
		[ config.services.anki-sync-server.baseDirectory ];

}
