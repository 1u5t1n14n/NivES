{ lib, config, ... }:

{

	systemd.tmpfiles.rules = [
		  "d /var/lib/private 0700 root root"
	];

	services = {
		nginx.virtualHosts."is.internal" = lib.mkIf config.services.homepage-dashboard.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://127.0.0.1:" + toString config.services.homepage-dashboard.listenPort;
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.homepage-dashboard.enable
			[ "192.168.178.185 is.internal" ];

		homepage-dashboard = {
			listenPort = 8082;
			allowedHosts = "127.0.0.1:${toString config.services.homepage-dashboard.listenPort},is.internal";

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
					]

					++ lib.optionals config.services.pihole-ftl.enable
						[{
							PiHole = {
								href = "http://192.168.178.185:8080";
								ping = "http://192.168.178.185:8080";
								icon = "pi-hole.svg";
							};
						}];
				}

				{
					Cloud = [ ]

					++ lib.optionals config.services.nextcloud.enable
						[{
							Nextcloud = {
								href = "http://" + config.services.nextcloud.hostName;
								ping = "http://" + config.services.nextcloud.hostName;
								icon = "nextcloud.svg";
							};
						}]

					++ lib.optionals config.services.immich.enable
						[{
							Immich = {
								href = "http://album.is.internal";
								ping = "http://${config.services.immich.host}:${toString config.services.immich.port}";
								icon = "immich.svg";
							};
						}]

					++ lib.optionals config.services.paperless.enable
						[{
							Paperless = {
								href = "http://less.is.internal";
								ping = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
								icon = "paperless.svg";
							};
						}];
				}

				{
					Sync = [ ]

					++ lib.optionals config.services.ntfy-sh.enable
						[{
							"ntfy.sh" = {
								href = "http://ntfy.is.internal";
								ping = "http://${config.services.ntfy-sh.settings.listen-http}";
								icon = "ntfy.svg";
							};
						}]

					++ lib.optionals config.services.anki-sync-server.enable
						[{
							Anki = {
								href = "http://anki.is.internal";
								ping = "http://${config.services.anki-sync-server.address}:${toString config.services.anki-sync-server.port}";
							};
						}];
				}

				{
					Miscellaneous = [ ]

					++ lib.optionals config.services.gitea.enable
						[{
							Gitea = {
								href = "http://git.is.internal";
								ping = "http://${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
								icon = "gitea.svg";
							};
						}];
				}
			];
		};
	};

}
