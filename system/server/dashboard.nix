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
				Networking = [
					{
						FritzBox = {
							href = "http://fritz.box";
							ping = "http://fritz.box";
							icon = "fritzbox.svg";
						};
					}
					{
						PiHole = {
							href = "http://192.168.178.185:8080";
							ping = "http://192.168.178.185:8080";
							icon = "pi-hole.svg";
						};
					}
				];
			}

			{
				Cloud = [
					{
						OpenCloud = {
							href = "https://192.168.178.185:9200";
							ping = "https://192.168.178.185:9200";
							icon = "open-cloud.svg";
						};
					}
					{
						Immich = {
							href = "http://192.168.178.185:2283";
							ping = "http://192.168.178.185:2283";
							icon = "immich.svg";
						};
					}
				];
			}

			{
				Sync = [
					{
						"ntfy.sh" = {
							href = "http://192.168.178.185:8088";
							ping = "http://192.168.178.185:8088";
							icon = "ntfy.svg";
						};
					}
					{
						Anki = {
							href = "http://192.168.178.185:27701";
							ping = "http://192.168.178.185:27701";
						};
					}
				];
			}

			{
				Miscellaneous = [
					{
						Gitea = {
							href = "http://192.168.178.185:8880";
							ping = "http://192.168.178.185:8880";
							icon = "gitea.svg";
						};
					}
				];
			}
		];

		openFirewall = true;
	};

}
