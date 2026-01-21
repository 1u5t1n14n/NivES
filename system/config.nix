{ config, lib, pkgs, host, ... }:

{

	imports = [
		./shared/options ./shared ./hosts/${host.name}.nix
	]
	++ lib.optionals host.desktop
		[ ./desktop ]
	++ lib.optionals (!host.desktop)
		[ ./server ];

	environment.systemPackages = [ pkgs.home-manager ];
	system.activationScripts.backupRemove = ''
		find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup" -delete
	'';

}
