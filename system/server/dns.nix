{ lib, config, ... }:

{

	services = {
		pihole-ftl = {

			lists = [
				{
					url = "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/all_domains.txt";
					type = "block";
					enabled = true;
					description = "Advertisements";
				}
				{
					url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt";
					type = "block";
					enabled = true;
					description = "Tracking";
				}
			];

			openFirewallDNS = true;
			openFirewallWebserver = true;

			settings = {
				dns = {
					upstreams = [ "1.1.1.1" "9.9.9.9" ];
					hosts = [
						"192.168.178.185 anki.is.internal"		# Anki-Sync-Server
						"192.168.178.1 fritz.box"
					];
					domainNeeded = true;
					expandHosts = true;
					ignoreLocalhost = true;
				};

				misc = {
					# Change to `3`, when everything is working
					privacylevel = 0;
					readOnly = true;
				};

				webserver = {
					excludeDomains = [ ];
				};
			};
		};

		pihole-web = {
			enable = config.services.pihole-ftl.enable;
			ports = [ 8080 ];
		};
	};

}
