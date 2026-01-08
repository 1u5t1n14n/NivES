{ pkgs, host, ... }:

{

	environment = {
		systemPackages = [ pkgs.ssh-to-age pkgs.sops ];
		persistence."/persist" = {
			directories = [ "/etc/ssh" ];
			users.${host.user}.directories = [ ".local/share/keyrings" ];
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

}
