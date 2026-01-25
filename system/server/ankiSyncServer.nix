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
				passwordFile = lib.mkIf config.extra.secretsEnabled
					config.sops.secrets."anki/main".path;
			}
		];
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.anki-sync-server.enable
		[ config.services.anki-sync-server.baseDirectory ];

}
