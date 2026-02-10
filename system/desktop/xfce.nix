{ pkgs, ... }:

{

	services.xserver = {
		enable = true;

		desktopManager.xfce.enable = true;
	};

	environment.xfce.excludePackages = with pkgs.xfce; [
		xfce4-screenshooter
	];

}
