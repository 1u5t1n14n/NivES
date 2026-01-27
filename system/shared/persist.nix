{ lib, host, ... }:

{

	environment.persistence."/persist" = {
		enable = lib.mkDefault false;
		hideMounts = true;
		allowTrash = host.desktop;

		# Important (I think)
		directories = [ "/var/lib/nixos" ];
	};

}
