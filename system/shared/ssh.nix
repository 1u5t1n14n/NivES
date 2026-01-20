{ host, config, ... }:

{

	users.users.${host.user}.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP9kyiHSaLuGocie+qs2a5jXRRzsOpruo2P+Bq5j4fS user@Thanatos"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINduKkKYcK2ef0B7n63abU009TjGYdVC+Oqmtbsdflks user@Prometheus"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHcp2AjNY9/YQOnOsC40WZE79/9z+whkatioUMfImg+ user@Morpheus"
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
