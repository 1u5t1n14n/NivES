{ modulesPath, config, lib, ... }:

{

	imports = [(modulesPath + "/installer/scan/not-detected.nix")];

	nixpkgs.hostPlatform = "x86_64-linux";

	hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote.enable = true;

		initrd = {
			availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

	networking.hostId = "8425e349";
	environment.persistence."/persist".enable = true;

	# Did you read the Comment?
	# Change to your system.stateVersion
	system.stateVersion = "25.11";

}
