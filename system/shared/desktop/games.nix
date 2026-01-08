{ pkgs, config, ... }:

{

	programs.steam.enable = config.nixpkgs.config.allowUnfree;

	environment.systemPackages = [ pkgs.prismlauncher ];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = [ pkgs.intel-media-driver ];
	};

}
