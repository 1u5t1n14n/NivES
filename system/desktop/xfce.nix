{ pkgs, ... }:

{

	services.xserver = {
		enable = config.services.xserver.desktopManager.xfce.enable;

		# To be enabled later
		desktopManager.xfce.enable = false;
	};

	environment.xfce.excludePackages = with pkgs.xfce; [
		xfce4-screenshooter
	];

}
