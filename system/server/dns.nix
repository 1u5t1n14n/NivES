{ lib, config, ... }:

{

	services = {
		pihole-ftl = {

			lists = [
				{
					url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
					type = "block";
					enabled = true;
					description = "hagezi's Ultimate Blocklist";
				}
			]

			++ lib.optionals false
				[{
					url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt";
					type = "block";
					enabled = true;
					description = "hagezi's Ultimate Blocklist";
				}];

			openFirewallDNS = true;
			openFirewallWebserver = true;

			settings = {
				dns = {
					upstreams = [ "1.1.1.1" ];
					hosts = [
						"192.168.178.185 our.home"
						"192.168.178.185 cloud.our.home"
						"192.168.178.185 less.our.home"
						"192.168.178.1 fritz.box"
					];
					domainNeeded = true;
					expandHosts = true;
				};

				misc = {
					# Change to `3`, when everything is working
					privacylevel = 0;

					# Probably needed?
					readOnly = true;
				};
			};
		};

		pihole-web = {
			enable = config.services.pihole-ftl.enable;
			ports = [ 8080 ];
		};
	};

}
