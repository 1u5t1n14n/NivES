{ ... }:

{

	programs.firefox.profiles.default.settings = {
		# Implicit Outbound
		"network.prefetch-next" = false;
		"network.dns.disablePrefetch" = true;
		"network.dns.disablePrefetchFromHTTPS" = true;
		"network.predictor.enabled" = false;
		"network.predictor.enable-prefetch" = false;
		"network.http.speculative-parallel-limit" = 0;
		"browser.places.speculativeConnect.enabled" = false;
		"browser.send_pings" = false;

		# DNS DoH Proxy Socks
		"network.proxy.socks_remote_dns" = true;
		"network.file.disable_unc_paths" = true;
		"network.gio.supported-protocols" = "";

		# Search
		"browser.urlbar.speculativeConnect.enabled" = false;
		#"browser.urlbar.quicksuggest.enabled" = false;
		"browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
		"browser.urlbar.suggest.quicksuggest.sponsored" = false;
		#"browser.search.suggest.enabled" = false;
		#"browser.urlbar.suggest.searches" = false;
		"browser.urlbar.trending.featureGate" = false;
		"browser.urlbar.addons.featureGate" = false;
		"browser.urlbar.fakespot.featureGate" = false;
		"browser.urlbar.mdn.featureGate" = false;
		"browser.urlbar.pocket.featureGate" = false;
		"browser.urlbar.weather.featureGate" = false;
		"browser.urlbar.yelp.featureGate" = false;
		"browser.urlbar.clipboard.featureGate" = false;
		
		"browser.urlbar.suggest.engines" = false;
		"layout.css.visited_links_enabled" = false;
		"full-screen-api.warning.timeout" = 0;
		
		# Disk Avoidance
		"browser.cache.disk.enable" = false;
		"browser.cache.memory.enable" = true;
		"browser.sessionstore.interval" = 600000;
		"browser.privatebrowsing.forceMediaMemoryCache" = true;
		"media.memory_cache_max_size" = 65536;
		"browser.sessionstore.privacy_level" = 2;
		"toolkit.winRegisterApplicationRestart" = false;
		"browser.shell.shortcutFavicons" = false;

		# HTTPS
		"security.ssl.require_safe_negotiation" = true;
		"security.tls.enable_0rtt_data" = true;

		"security.OCSP.enabled" = 1;
		"security.OCSP.require" = true;

		"security.cert_pinning.enforcement_level" = 2;
		"security.remote_settings.crlite_filters.enabled" = true;
		"security.pki.crlite_mode" = 2;

		"dom.security.https_only_mode" = true;
		"dom.security.https_only_mode_send_http_background_request" = false;
		
		"security.ssl.treat_unsafe_negotiation_as_broken" = true;
		"browser.xul.error_pages.expert_bad_cert" = true;

		# Referers
		"network.http.referer.XOriginTrimmingPolicy" = 2;

		# Containers
		"privacy.userContext.enabled" = true;
		"privacy.userContext.ui.enabled" = true;
		"browser.link.force_default_user_context_id_for_external_opens" = false;
		"extensions.autoDisableScopes" = 0;

		# Plugins
		"media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
		"media.peerconnection.ice.default_address_only" = true;

		# DOM
		"dom.disable_window_move_resize" = true;

		# Miscellaneous
		"ui.caretBlinkTime" = 0;
		"browser.helperApps.deleteTempFileOnExit" = true;
		"browser.uitour.enabled" = false;
		"devtools.debugger.remote-enabled" = false;
		"permissions.manager.defaultsUrl" = "";
		"network.IDN_show_punycode" = true;
		"pdfjs.disabled" = false;
		"pdfjs.enableScripting" = false;
		"browser.tabs.searchclipboardfor.middleclick" = false;
		"browser.contentanalysis.enabled" = false;
		"browser.contentanalysis.default_result" = 0;
		"browser.backspace_action" = 0;

		# Downloads
		"browser.download.open_pdf_attachments_inline" = true;
		"browser.download.useDownloadDir" = false;
		"browser.download.alwaysOpenPanel" = false;
		"browser.download.manager.addToRecentDocs" = false;
		"browser.download.always_ask_before_handling_new_types" = true;
		"extensions.postDownloadThirdPartyPrompt" = false;
		"extensions.webextensions.restritedDomains" = "";

		# Sanitize
		"privacy.clearOnShutdown.cache" = true;
		"privacy.clearOnShutdown_v2.cache" = true;
		"privacy.clearOnShutdown.downloads" = true;
		"privacy.clearOnShutdown.formdata" = true;
		"privacy.clearOnShutdown.history" = true;
		"privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
		
		"privacy.clearOnShutdown.cookies" = true;
		"privacy.clearOnShutdown.offlineApps" = true;
		"privacy.clearOnShutdown.sessions" = false;
		"privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
		
		"privacy.clearSiteData.cache" = true;
		"privacy.clearSiteData.cookiesAndStorage" = false;
		"privacy.clearSiteData.historyFormDataAndDownloads" = true;
		
		"privacy.sanitize.timeSpan" = 0;

		# Fingerprinting
		"privacy.resistFingerprinting.block_mozAddonManager" = true;
		"browser.link.open_newwindow" = 1;
		"browser.link.open_newwindow.restriction" = 0;

		# Preferences
		"browser.download.folderList" = 2;
		"layout.css.prefers-color-scheme.content-override" = 0;
		"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
		"dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
		"browser.toolbars.bookmarks.visibility" = "never";
		"browser.download.autohideButton" = false;
		#"keyword.enabled" = false;
		"browser.startup.homepage_override.mstone" = "ignore";

		"browser.tabs.closeTabByDblclick" = true;
		"browser.tabs.closeWindowWithLastTab" = false;
		"browser.warnOnQuit" = false;
		"browser.warnOnQuitShortcut" = false;
	};

}
