{ host, config, ... }:

{

	users.users.${host.user}.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP9kyiHSaLuGocie+qs2a5jXRRzsOpruo2P+Bq5j4fS Thanatos"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINH7Wl16herw523R0RoGrYanw36UsjF09OfLbGyk1aEv Apollon"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHcp2AjNY9/YQOnOsC40WZE79/9z+whkatioUMfImg+ Morpheus"
	];

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
			enable = true;
			maxretry = 5;
			bantime = "2h";

			bantime-increment = {
				enable = true;
				multipliers = "1 2 4 8 16 32 64 128 256";
				maxtime = "168h";
				overalljails = true;
			};
		};
	};

}
