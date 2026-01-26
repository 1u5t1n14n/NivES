{ config, ... }:

{

	services.homepage-dashboard = {
		listenPort = 8082;
		allowedHosts = "localhost:${
				toString config.services.homepage-dashboard.listenPort
			},127.0.0.1:${
				toString config.services.homepage-dashboard.listenPort
			},192.168.178.185:${
				toString config.services.homepage-dashboard.listenPort
			}";

		openFirewall = true;
	};

}
