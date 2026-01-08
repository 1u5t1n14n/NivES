{ pkgs, lib, config, ... }:

{

	fonts = {
		fontDir.enable = true;
		enableDefaultPackages = true;
		packages = with pkgs; [
			jost eb-garamond inter noto-fonts unifont
			ibm-plex

			nerd-fonts.blex-mono nerd-fonts.jetbrains-mono
		]

		++ lib.optionals config.nixpkgs.config.allowUnfree
			[ corefonts symbola ];
	};

}
