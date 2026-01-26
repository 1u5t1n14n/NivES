{ config, lib, ... }:

{

	services.immich = {
		port = 2283;
		host = "0.0.0.0";
		openFirewall = (config.services.immich.host == "0.0.0.0");
	};

	environment.persistence."/persist".directories = lib.mkIf config.services.immich.enable
		[ config.services.immich.mediaLocation config.services.postgresql.dataDir ];

}
