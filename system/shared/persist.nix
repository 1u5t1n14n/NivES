{ lib, host, ... }:

{

	environment.persistence."/persist" = {
		enable = lib.mkDefault false;
		hideMounts = true;

		# Important (I think)
		directories = [ "/var/lib/nixos" ];
	};

}
