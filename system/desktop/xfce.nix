{ pkgs, config, lib, ... }:

{

	services.xserver = {
		enable = config.services.xserver.desktopManager.xfce.enable;

		# To be enabled later
		desktopManager.xfce.enable = lib.mkDefault false;
		displayManager.lightdm.enable = config.services.xserver.desktopManager.xfce.enable;
	};

	environment.xfce.excludePackages = with pkgs.xfce; [
	];

}
