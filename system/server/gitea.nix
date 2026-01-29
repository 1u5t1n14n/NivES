{ config, ... }:

{

	services.gitea = {
		settings = {
			server = {
				HTTP_PORT = 8880;
			};

			service = {
				DISABLE_REGISTRATION = true;
			};

			session = {
				COOKIE_SECURE = false;
			};
		};
	};

	networking.firewall.allowedTCPPorts = [ config.services.gitea.settings.server.HTTP_PORT ];

}
