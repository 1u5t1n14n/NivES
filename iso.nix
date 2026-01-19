{ modulesPath, pkgs, lib, ... }:

{

	imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];

	environment.systemPackages = [ pkgs.neovim ];

	console.keyMap = "de";

	users.users.root.initialHashedPassword = lib.mkForce "$y$j9T$JK3zZQcvq024wP84fbucq/$74F0lE9/Y.6dy68yp2jpOaicF4axaReIoi6B8bnu8t0";

	isoImage.squashfsCompression = "gzip -Xcompression-level 1";

}
