{ config, host, pkgs, ... }:

{

	nix.settings.allowed-users = [ "@wheel" "root" host.user ];

	users = {
		# mutableUsers = false;

		users = {
			# root.hashedPasswordFile = config.sops.secrets."user/root".path;
			${host.user} = {
				isNormalUser = true;
				createHome = true;
				initialPassword = "Password";
				# hashedPasswordFile = config.sops.secrets."user/main".path;

				extraGroups = [ "networkmanager" "wheel" ];

				description = host.user;
				packages = with pkgs; [ ];
			};
		};
	};

}
