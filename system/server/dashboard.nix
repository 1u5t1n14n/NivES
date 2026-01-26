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

		widgets = [
			{
				resources = {
					cpu = true;
					disk = "/";
					memory = true;
				};
			}
		];

		services = [
			{
				Sync = [
					{
						Immich = {
							description = "Easily synchronise your Photos";
							href = "http://192.168.178.185:2283";
							ping = "http://192.168.178.185:2283";
							icon = "immich.svg";
						};
					}
				];
			}
		];

		openFirewall = true;
	};

}
