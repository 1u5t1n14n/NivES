{ lib, ... }:

{

	nixpkgs.hostPlatform = "x86_64-linux";

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote.enable = true;
		initrd = {
			availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
			kernelModules = [ ];
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

	environment.persistence."/persist".enable = true;

	# Did you read the Comment?
	# Change to your system.stateVersion
	system.stateVersion = "25.11";


}
