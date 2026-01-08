{ host, inputs, pkgs, ... }:

{

	services.vicinae = {
		enable = host.desktop;

		systemd = {
			enable = true;
			autoStart = true;
			environment = {
				USE_LAYER_SHELL = 1;
			};
		};

		settings = {
			close_on_focus_loss = true;
			pop_to_root_on_close = true;
			search_files_in_root = true;
			#consider_preedit = true;

			font = {
				normal = {
					# size = 12;
					normal = "Inter";
				};
			};
			theme = {
				light = {
					name = "vicinae-light";
					icon_theme = "default";
				};
				dark = {
					name = "catppuccin-mocha";
					icon_theme = "default";
				};
			};
			#launcher_window = {
			#opacity = 0.98;
			#};
		};

		extensions = with inputs.vicinaeExtensions.packages.${pkgs.stdenv.hostPlatform.system};
			[ nix firefox ];
	};

}
