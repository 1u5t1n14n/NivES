{ config, host, pkgs, lib, ... }:

{

	nix.settings.allowed-users = [ "@wheel" "root" host.user ];

	users = {
		mutableUsers = !config.extra.secretsEnabled;

		users = {
			root.hashedPasswordFile = lib.mkIf config.extra.secretsEnabled
				config.sops.secrets."user/root".path;
			root.initialPassword = lib.mkIf (!config.extra.secretsEnabled)
				"Gurkensalat";

			${host.user} = {
				isNormalUser = true;
				createHome = true;

				hashedPasswordFile = lib.mkIf config.extra.secretsEnabled
					config.sops.secrets."user/main".path;
				initialPassword = lib.mkIf (!config.extra.secretsEnabled)
					"Password";

				extraGroups = [ "networkmanager" "wheel" ];
				description = host.user;
				packages = with pkgs; [ ];
			};
		};
	};

	sops.secrets = lib.mkIf config.extra.secretsEnabled
		{
			"user/root".neededForUsers = true;
			"user/main".neededForUsers = true;
		};

}
