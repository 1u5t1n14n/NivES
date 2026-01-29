{ host, lib, config, ... }:

let
	getUrl = addonName: authorId: 
		"http://addons.mozilla.org/firefox/downloads/latest/${addonName}/addon-${toString authorId}-latest.xpi";

in
{

	programs.firefox = {
		enable = true;
		languagePacks = [ "de" "en-GB" ];
		policies = {
			AppAutoUpdate = false;
			AutofillAddressEnabled = false;
			AutofillCreditCardEnabled = false;
			NewTabPage = false;
			OfferToSaveLogins = false;
			NoDefaultBookmarks = true;
			ShowHomeButton = false;
			DisplayBooksmarksToolbar = "never";
			PasswordManagerEnabled = false;
			PromptForDownloadLocations = true;

			StartDownloadsInTempDirectory = true;

			Cookies = {
				Behavior = "reject-foreign";
				Block = [
					"https://google.com"
					"https://facebook.com"
					"https://instagram.com"
					"https://microsoft.com"
				];
			};
			EnableTrackingProtection = {
				Value = true;
				Locked = true;

				Category = "strict";

				Cryptomining = true;
				EmailTracking = true;
				SuspectedFingerprinting = true;
				Fingerprinting = true;
			};
			HttpsOnlyMode = "enabled";
			SanitizeOnShutdown = {
				FormData = true;
				SiteSettings = true;
				Cache = true;
				Locked = true;
			};

			GenerativeAI = {
				Enabled = false;
				Locked = true;
			};
			SearchEngines.Remove = [ "Perplexity" ];

			UserMessaging = {
				ExtensionRecommendations = false;
				FeatureRecommendations = false;
				UrlbarInterventions = false;
				SkipOnboarding = true;
				MoreFromMozilla = false;
				FirefoxLabs = false;
				Locked = true;
			};

			CaptivePortal = false;
			DisableAccounts = true;
			DisableEncryptedClientHello = true;
			DisableFeedbackCommands = true;
			DisableFirefoxAccounts = true;
			DisableFirefoxScreenshots = true;
			DisableFirefoxStudies = true;
			DisableFormHistory = true;
			DisableSetDesktopBackground = true;
			DisableTelemetry = true;

			DontCheckDefaultBrowser = true;

			Extensions = {
				Install = [
					(getUrl "vimium-ff" 14971172)
					(getUrl "ublock-origin" 11423598)
					(getUrl "clearurls" 13196993)
					(getUrl "consent-o-matic" 18863655)
					(getUrl "facebook-container" 4757633)
					(getUrl "nicothin-space" 12632157)

					# (getUrl "tineye-reverse-image-search" 3304309)
					# (getUrl "localtube-manager" 18857709)
				];
			};
		};
	};

	environment = lib.mkIf config.programs.firefox.enable
		{
			persistence."/persist".users.${host.user}.directories = [ ".mozilla/firefox" ];
			sessionVariables = {
				MOZ_USE_XINPUT2 = "1";
				MOZ_ENABLE_WAYLAND = "1";
			};
		};

}
