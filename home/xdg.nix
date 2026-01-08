{ config, lib, ... }:

{

	xdg = {
		mime.enable = true;
		mimeApps = {
			enable = true;
			defaultApplications = {
				"x-scheme-handler/http" = lib.mkIf config.programs.firefox.enable [ "firefox.desktop" ];
				"x-scheme-handler/https" = lib.mkIf config.programs.firefox.enable [ "firefox.desktop" ];
				"x-scheme-handler/about" = lib.mkIf config.programs.firefox.enable [ "firefox.desktop" ];
				"x-scheme-handler/unknown" = lib.mkIf config.programs.firefox.enable [ "firefox.desktop" ];
			};
		};
	};

}
