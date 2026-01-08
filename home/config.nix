{ host, osConfig, ... }:

{

	imports = [
		./firefox
		./git.nix
		./gnome
		./gtk.nix
		./niri
		./nixvim
		./vicinae.nix
		./waybar.nix
		./wezterm.nix
		./xdg.nix
		./zed.nix
	];

	home = {
		username = host.user;
		homeDirectory = osConfig.users.users.${host.user}.home;
		stateVersion = "25.11";
		packages = [ ];
	};

	programs.home-manager.enable = true;

}
