{ pkgs, host, config, ... }:

{

	programs = {
		localsend = {
			enable = true;
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

		persistence."/persist".users.${host.user}.directories = [ ".config/Bitwarden" ]

		++ lib.optionals config.programs.thunderbird.enable
			[ ".thunderbird" ];
	};

}
