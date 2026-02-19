{ config, lib, ... }:

{

	services = {
		nginx.virtualHosts.${config.services.gitlab.host} = lib.mkIf config.services.gitlab.enable
			{
				forceSSL = false;
				enableACME = false;
				locations."/" = {
					proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
					proxyWebsockets = true;
				};
			};
		pihole-ftl.settings.dns.hosts = lib.mkIf config.services.gitlab.enable
			[ ("192.168.178.185 " + config.services.gitlab.host) ];

		gitlab = {
			host = "code.is.internal";

			databasePasswordFile = config.sops.secrets."services/gitlab/db".path;
			initialRootPasswordFile = config.sops.secrets."services/gitlab/root".path;

			secrets = {
				secretFile = config.sops.secrets."services/gitlab/secret".path;
				otpFile = config.sops.secrets."services/gitlab/otp".path;
				dbFile = config.sops.secrets."services/gitlab/dbFile".path;
				jwsFile = config.sops.secrets."services/gitlab/jws".path;
			};
		};
	};

	sops.secrets = {
		"services/gitlab/db".owner = config.services.gitlab.user;
		"services/gitlab/root".owner = config.services.gitlab.user;
		"services/gitlab/secret".owner = config.services.gitlab.user;
		"services/gitlab/otp".owner = config.services.gitlab.user;
		"services/gitlab/dbFile".owner = config.services.gitlab.user;
		"services/gitlab/jws".owner = config.services.gitlab.user;
	};

}
