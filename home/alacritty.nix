{ ... }:

{

	programs.alacritty = {
		enable = true;
		settings = {
			cursor.style = {
				shape = "Block";
				blinking = "Off";
			};
			general.live_config_reload = true;

			window = {
				decorations = "None";
				opacity = 0.95;
			};
		};
	};

}
