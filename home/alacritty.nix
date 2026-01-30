{ ... }:

{

	programs.alacritty = {
		enable = true;
		theme = "campbell";
		settings = {
			general.live_config_reload = true;
			cursor.style = {
				shape = "Block";
				blinking = "Off";
			};
			window = {
				decorations = "None";
				opacity = 0.95;
			};
			font.size = 12.3;
		};
	};

}
