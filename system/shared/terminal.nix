{ config, lib, host, pkgs, ... }:

{

	programs = {
		bat = {
			enable = true;
			settings = { };
			extraPackages = with pkgs.bat-extras; [
				batman batwatch core batgrep batpipe batdiff prettybat
			];
		};

		lazygit = {
			enable = true;
			settings = { };
		};

		neovim = {
			# To be continued via NixVim
			enable = true;
			viAlias = true;
			vimAlias = true;
			defaultEditor = true;
		};

		nano.enable = true;
		git.enable = true;

		gnupg.agent = {
			enable = true;
			pinentryPackage = pkgs.pinentry-curses;
			enableSSHSupport = !config.programs.ssh.startAgent;
		};
	};

	services.pcscd.enable = (
		(config.programs.gnupg.agent.pinentryPackage == pkgs.pinentry-curses)
		&& config.programs.gnupg.agent.enable
	);

	environment = {
		systemPackages = with pkgs; [
			ripgrep fastfetch onefetch tree gcc tree-sitter
			fastfetch fzf figlet zip unzip wget yt-dlp btop
			gh cmatrix browsh imagemagick superfile gnumake
			pandoc typst gnupg lynx ffmpeg-full texliveFull
			bitwarden-cli ocrmypdf cava zbar glow
			inotify-tools flying-carpet
		]

		++ lib.optionals host.desktop
			[ wl-clipboard ];

		persistence."/persist".users.${host.user} = {
			files = lib.mkIf config.programs.lazygit.enable
				[ ".local/state/lazygit/state.yml" ];

			directories = lib.mkIf (builtins.elem pkgs.gh config.environment.systemPackages)
				[ ".config/gh" ]

			++ lib.optionals (builtins.elem pkgs.bitwarden-cli config.environment.systemPackages)
				[ ".config/Bitwarden" ]
		};
	};

	# Doctor: Yes, I think it is terminal.
}
