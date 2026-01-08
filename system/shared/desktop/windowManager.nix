{ pkgs, ... }:

{

	programs = {
		niri.enable = true;
		waybar.enable = true;
	};

	environment.systemPackages = [
		pkgs.swww pkgs.niriswitcher
	];

}
