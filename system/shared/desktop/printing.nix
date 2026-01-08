{ pkgs, ... }:

{

	services = {
		printing = {
			enable = true;
			drivers = with pkgs; [ ];
		};

		avahi = {
			enable = true;
			nssmdns4 = true;
			openFirewall = true;
		};
	};

}
