{ lib, ... }:

{

	nixpkgs.hostPlatform = "x86_64-linux";

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote.enable = true;
		initrd = {
			availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];

			# Not working with SD Card Reader
			luks.devices.luks = {
				keyFile = null;
				keyFileTimeout = null;
				keyFileSize = null;
			};
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

	environment.persistence."/persist".enable = true;

	# Did you read the Comment?
	# Change to your system.stateVersion
	system.stateVersion = "25.11";

}
