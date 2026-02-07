{ pkgs, host, config, ... }:

{

	environment = {
		systemPackages = [ pkgs.ssh-to-age pkgs.sops ];

		persistence."/persist" = {
			directories = [ "/etc/ssh" ];
			users.${host.user}.directories = [ { directory = ".config/sops/age/"; mode = "700"; } ];
		};
	};


	sops = {
		log = [ "secretChanges" ];
		defaultSopsFile = ../../keys.yaml;
		defaultSopsFormat = "yaml";

		age = {
			keyFile = "/etc/sops/age/keys.txt";
			sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
			generateKey = true;
		};
		validateSopsFiles = true;
	};

	# Not even working because /home is not mounted during activation.
	system.activationScripts.ageKeys = ''
		${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /persist/etc/ssh/ssh_host_ed25519_key -o ${config.users.users.${host.user}.home}/.config/sops/age/keys.txt
	'';

}
