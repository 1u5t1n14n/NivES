{ config, lib, pkgs, host, ... }:

{

	imports = [
		./shared/options ./shared ./hosts/${host.name}.nix
	]
	++ lib.optionals host.desktop
		[ ./desktop ]
	++ lib.optionals (!host.desktop)
		[ ./server ];

	# Home-Manager
	environment.systemPackages = [ pkgs.home-manager ];

	# Work-around for continued Systemd Service. Probably
	# other way to prevent erroring out.
	system.activationScripts.backupRemove = ''
		find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup" -delete
	'';

	# Needed for Home-Manager Usage with Impermanence
	# Probably easier to do, but who cares
	system.userActivationScripts.backupRemove = config.system.activationScripts.backupRemove;

}
