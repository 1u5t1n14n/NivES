{ pkgs, host, config, lib, ... }:

{

	programs = {
		localsend = {
			enable = false;
			openFirewall = true;
		};

		thunderbird = {
			enable = true;
			policies = {
				CaptivePortal = false;
				DisableTelemetry = true;
				OfferToSaveLogins = false;
				PasswordManagerEnabled = false;
			};
		};
	};

	environment = {
		systemPackages = with pkgs; [
			bitwarden-desktop signal-desktop ente-auth ungoogled-chromium
		];

		persistence."/persist".users.${host.user}.directories = [ ]

		++ lib.optionals (builtins.elem
				pkgs.bitwarden-desktop
				config.environment.systemPackages)
			[ ".config/Bitwarden" ]

		++ lib.optionals (builtins.elem
				pkgs.ente-auth
				config.environment.systemPackages)
			[ ".local/share/io.ente.auth" ]

		++ lib.optionals config.programs.thunderbird.enable
			[ ".thunderbird" ];
	};

}
