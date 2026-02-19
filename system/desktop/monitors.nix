{ config, pkgs, lib, ... }:

{

	services.xserver = {
		videoDrivers = [ "modesetting" ]

		++ lib.optionals config.nixpkgs.config.allowUnfree
			[ "displaylink" ];

		displayManager.sessionCommands = lib.mkIf config.services.desktopManager.gnome.enable
			''
				${lib.getBin pkgs.xrandr}/bin/xrandr --setprovideroutputsource 2 0
			'';
	};

	environment.systemPackages = [ pkgs.xrandr ]

	++ lib.optionals config.nixpkgs.config.allowUnfree
		[ pkgs.displaylink ];

	boot = {
		extraModulePackages = [ config.boot.kernelPackages.evdi ];
		initrd.kernelModules = [ "evdi" ];
	};
	systemd.services.dlm.wantedBy = lib.mkIf config.nixpkgs.config.allowUnfree
		[ "multi-user.target" ];

}
