{ ... }:

{

	nixpkgs.hostPlatform = "x86_64-linux";
	disko.devices.disk.main.device = "/dev/sda";
	hardware.enableAllFirmware = false;

	boot = {
		initrd = {
			availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
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

}
