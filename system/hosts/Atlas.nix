{ lib, ... }:

{

	nixpkgs.hostPlatform = "x86_64-linux";

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote.enable = true;
		initrd = {
			availableKernelModules = [ "xhci_pci" "ahci" "sd_mod" ];
			kernelModules = [ ];
			luks.devices.luks.keyFile = "/dev/sdb";
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

	environment.persistence."/persist".enable = true;
	extra.secretsEnabled = false;

	# Did you read the Comment?
	# Change to your system.stateVersion
	system.stateVersion = "25.11";

	services = {
		paperless.enable = false;
		nextcloud.enable = false;
		opencloud.enable = false;
		anki-sync-server.enable = false;
		immich.enable = false;
		pihole-ftl.enable = false;
	};

}
