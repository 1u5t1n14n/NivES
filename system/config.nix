{ config, lib, pkgs, host, ... }:

{

	imports = [
		./shared/options ./shared ./hosts/${host.name}.nix
	]
	++ lib.optionals host.desktop
		[ ./shared/desktop ]
	++ lib.optionals (!host.desktop)
		[ ./shared/server ];

	environment.systemPackages = [ pkgs.home-manager ];
	system.activationScripts.backupRemove = ''
		find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup" -delete
	'';

}
