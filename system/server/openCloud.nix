{ lib, config, ... }:

{

	services.opencloud = {
		port = 9200;
		address = "0.0.0.0";

		url = lib.mkIf (config.services.opencloud.address == "0.0.0.0")
			"http://192.168.178.178:9200";
		environment = {
			INITIAL_ADMIN_PASSWORD = "Password";
		};
	};

	networking.firewall.allowedTCPPorts = lib.mkIf (config.services.opencloud.address == "0.0.0.0")
		[ config.services.opencloud.port ];

	environment.persistence."/persist".directories = lib.mkIf config.services.opencloud.enable
		[{
			directory = config.services.opencloud.stateDir;
			user = config.services.opencloud.user;
			group = config.services.opencloud.group;
			mode = "0700";
		}];

}
