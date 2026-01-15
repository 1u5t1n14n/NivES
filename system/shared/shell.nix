{ lib, host, config, pkgs, ... }:

{

	programs.zsh = {
		enable = lib.mkIf (config.users.users.${host.user}.shell == pkgs.zsh) true;

		enableCompletion = true;
		syntaxHighlighting.enable = true;
		autosuggestions = {
			enable = true;
			strategy = [ "history" "completion" ];
		};

		histSize = 10000;
		histFile = "$HOME/.zshHistory";

		shellAliases = { };
	};

	users.defaultUserShell = config.users.users.${host.user}.shell;
	environment = {
		persistence."/persist".users.${host.user}.files = lib.mkIf config.programs.zsh.enable
			[ ".zshHistory" ];
		shells = [ config.users.users.${host.user}.shell ];
		systemPackages = [ config.users.users.${host.user}.shell ];
	};

	system.userActivationScripts.zsh = lib.mkIf config.programs.zsh.enable
		''
			touch .zshrc
		'';

}
