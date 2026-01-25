{ lib, config, ... }:

{

	services.opencloud = {
		port = 9200;
		address = "0.0.0.0";

		url = lib.mkIf (config.services.opencloud.address == "0.0.0.0")
			"http://192..168178.178" + config.services.opencloud.port;
		environment = {
			INITIAL_ADMIN_PASSWORD = "Password";
		};
	};

	networking.firewall.allowedTCPPorts = lib.mkIf (config.services.opencloud.address == "0.0.0.0")
		[ config.services.opencloud.port ];

	environment.persistence."/persist".directories = lib.mkIf config.services.opencloud.enable
		[ config.services.opencloud.stateDir ];

}
