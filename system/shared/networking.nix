{ host, lib, config, ... }:

{

	networking = {
		hostName = host.name;
		hostId = lib.mkDefault "8425e349";

		firewall.enable = true;
		nftables.enable = true;
	
		useDHCP = lib.mkDefault true;

		networkmanager = {
			enable = true;
			wifi.scanRandMacAddress = true;
		};

		hosts = {
			"192.168.178.185" = [
				"cloud.is.internal"
				"is.internal"
			];
		};
	};

	environment.persistence."/persist".directories = lib.mkIf config.networking.networkmanager.enable
		[ "/etc/NetworkManager/system-connections" ];

}
