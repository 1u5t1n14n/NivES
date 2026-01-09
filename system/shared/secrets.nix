{ pkgs, host, config, ... }:

{

	environment = {
		systemPackages = [ pkgs.ssh-to-age pkgs.sops ];
		persistence."/persist" = {
			directories = [ "/etc/ssh" ];
			files = [ "/etc/sops/age/keys.txt" ];
			users.${host.user}.directories = [ { directory = ".config/sops/age/"; mode = "700"; } ];
		};
	};


	sops = {
		log = [ "secretChanges" ];
		defaultSopsFile = ../../secrets.yaml;

		age = {
			keyFile = "/etc/sops/age/keys.txt";
			sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
			generateKey = true;
		};
		validateSopsFiles = true;
	};
	#TODO: Rest machn

	system.userActivationScripts.ageKeys = ''
		${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /persist/etc/ssh/ssh_host_ed25519_key -o ${config.users.users.${host.user}.home}/.config/sops/age/keys.txt

	'';

	# Possibly irrelevant due to Impermanence (?)
	# chown -R ${host.user}:${config.users.users.${host.user}.group} ${config.users.users.${host.user}.home}/.config/sops

}
