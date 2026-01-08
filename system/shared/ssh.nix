{ host, config, ... }:

{

	users.users.${host.user}.openssh.authorizedKeys.keys = [ ];

	services = {
		openssh = {
			enable = true;
			ports = [ 20001 ];
			openFirewall = true;

			startWhenNeeded = host.desktop;
			settings = {
				PasswordAuthentication = false;
				KbdInteractiveAuthentication = false;
				PermitRootLogin = "no";
				AllowUsers = [ host.user ];
			};

			allowSFTP = false;
		};

		fail2ban = {
			enable = config.services.openssh.enable;
			maxretry = 5;
			bantime = "2h";

			bantime-increment = {
				enable = true;
				multipliers = "1 2 4 8 16 32 64 128 256";
				maxtime = "168h";
				overalljails = true;
			};
		};

		endlessh = {
			enable = config.services.openssh.enable;
			port = 22;
			openFirewall = true;
		};
	};

}
