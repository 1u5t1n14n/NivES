{ config, ... }:

{

	services.freshrss = {
		defaultUser = "root";
		passwordFile = config.sops.secrets."services/rss".path;

		authType = "form";
		language = "de";

		baseUrl = "http://${config.services.freshrss.virtualHost}";
		virtualHost = "rss.is.internal";
	};

}
