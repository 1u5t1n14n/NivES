{ host, config, ... }:

{

	# TODO: Secret Management

	services.anki-sync-server = {
		enable = true;

		address = "0.0.0.0";
		port = 27701;
		openFirewall = (config.services.anki-sync-server.address == "0.0.0.0");

		users = [
			{ username = host.user; passwordFile = null; }
		];
	};

}
