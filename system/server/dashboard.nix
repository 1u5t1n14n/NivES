{ ... }:

{

	services.homepage-dashboard = {
		listenPort = 8082;
		allowedHosts = "localhost:${
				config.services.homepage-dashboard.listenPort
			},127.0.0.1:${
				config.services.homepage-dashboard.listenPort
			},192.168.178.185:${
				config.services.homepage-dashboard.listenPort
			}";

		openFirewall = true;
	};

}
