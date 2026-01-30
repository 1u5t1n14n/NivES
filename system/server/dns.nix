{ lib, config, ... }:

{

	services = {
		pihole-ftl = {

			lists = [
				{
					url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt";
					type = "block";
					enabled = true;
					description = "More Blocking than none.";
				}
				{
					url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/spam-tlds-adblock.txt";
					type = "block";
					enabled = true;
					description = "Malicious Domains";
				}
			];

			openFirewallDNS = true;
			openFirewallWebserver = true;

			settings = {
				dns = {
					upstreams = [ "1.1.1.1" "9.9.9.9" ];
					hosts = [
						# Hopefully Working...?

						"192.168.178.185 is.internal"			# Dashboard
						"192.168.178.185 cloud.is.internal"		# Nextcloud
						"192.168.178.185 ntfy.is.internal"		# ntfy.sh
						"192.168.178.185 git.is.internal"		# Gitea
						"192.168.178.185 anki.is.internal"		# Anki-Sync-Server
						"192.168.178.185 photos.is.internal"	# Immich
						"192.168.178.185 less.is.internal"		# Paperless
						"192.168.178.1 fritz.box"
					];
					domainNeeded = true;
					expandHosts = true;
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
