{ config, lib, ... }:

{

	services.mollysocket = {
		settings = {
			port = 8020;
			host = "0.0.0.0";

			allowed_endpoints = [ "https://ntfy.sh" ]

			++ lib.optionals config.services.ntfy-sh.enable
				[ config.services.ntfy-sh.settings.base-url ];
		};
	};

	networking.firewall.allowedTCPPorts = [ config.services.ntfy-sh.settings.port ];

}
