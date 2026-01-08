{ pkgs, host, ... }:

{

	programs = {
		localsend = {
			enable = true;
			openFirewall = true;
		};

		chromium = {
			enable = true;
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
		persistence."/persist".users.${host.user}.directories = [ ".config/Bitwarden" ];
	};

}
