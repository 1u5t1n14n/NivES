{ pkgs, config, lib, ... }:

{

	environment = {
		sessionVariables.ANKI_WAYLAND = "1";

		systemPackages = with pkgs; [
			zed-editor keepassxc wezterm anki-bin qemu quickemu xorg.xprop
			greenfoot zotero alacritty
		]

		++ lib.optionals config.nixpkgs.config.allowUnfree
			[ geogebra6 obsidian jetbrains.clion jetbrains-toolbox ];
	};

	xdg.terminal-exec = {
		enable = true;
		settings.default = [ "Alacritty.desktop" ];
	};

	services.blueman.enable = config.hardware.bluetooth.enable;
	hardware.bluetooth.enable = true;

}
