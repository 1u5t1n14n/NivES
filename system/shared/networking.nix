{ host, lib, ... }:

{

	networking = {
		hostName = host.name;

		firewall.enable = true;
		nftables.enable = true;
	
		useDHCP = lib.mkDefault true;

		networkmanager.enable = true;
	};

	environment.persistence."/persist".directories = [
		"/etc/NetworkManager/system-connections"
	];


}
