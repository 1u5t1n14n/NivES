{ host, ... }:

{

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
			download-buffer-size = 4 * 1024 * 1024 * 1024;

			extra-substituters = [ "https://vicinae.cachix.org" ];
			extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
		};

		gc = {
			automatic = true;
			dates = "daily";
			options = "--delete-older-than 3d";
		};
	};

	system.autoUpgrade = {
		flake = "github:1u5t1n14n/NixOS\#${host.name}";
		enable = false;
		allowReboot = !host.desktop;
		upgrade = host.desktop;
	};

	nixpkgs.config = {
		allowBroken = false;
		allowUnfree = false;
	};

}
