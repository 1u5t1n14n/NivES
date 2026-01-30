{ lib, ... }:

{

	nixpkgs.hostPlatform = "x86_64-linux";
	disko.devices.disk.main.device = "/dev/sda";

	boot = {
		# loader.systemd-boot.enable = lib.mkForce false;
		# lanzaboote.enable = false;
		initrd = {
			availableKernelModules = [ "usb_storage" "xhci_pci" "ahci" "sd_mod" ];
			kernelModules = [ ];
			luks.devices.luks.keyFile = "/dev/sdb";
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

	environment.persistence."/persist".enable = true;

	# Did you read the Comment?
	# Change to your system.stateVersion
	system.stateVersion = "25.11";

	services = {
		gitea.enable = false;
		ntfy-sh.enable = false;
		paperless.enable = false;
		nextcloud.enable = true;
		opencloud.enable = false;
		anki-sync-server.enable = true;
		immich.enable = true;
		pihole-ftl.enable = true;
		homepage-dashboard.enable = true;
	};

}
