{ lib, host, config, pkgs, ... }:

{

	programs.zsh = {
		enable = true;

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

	users.defaultUserShell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
	environment = {
		persistence."/persist".users.${host.user}.files = lib.mkIf config.programs.zsh.enable
			[ ".zshHistory" ".zshrc" ];
		shells = [ config.users.defaultUserShell ];
	};

}
