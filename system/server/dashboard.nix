{ lib, config, ... }:

{

	services = {
		nginx.virtualHosts."is.internal" = lib.mkIf (config.services.homepage-dashboard.enable)
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://" + config.services.homepage-dashboard.allowedHosts;
				};
			};

		homepage-dashboard = {
			listenPort = 8082;
			allowedHosts = "127.0.0.1:" + (toString config.services.homepage-dashboard.listenPort);

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
							Nextcloud = {
								href = "http://cloud.is.internal";
								ping = "http://cloud.is.internal";
								icon = "nextcloud.svg";
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

			openFirewall = false;
		};
	};

}
