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

	boot.initrd.systemd.services.backupRemove = {
		description = "Delete Home-Manager Backups";

		after = [ "sysroot.mount" ];
		before = [ "home-manager-${host.user}.service" ];
		wantedBy = [ "multi-user.target" ];

		unitConfig.DefaultDependencies = "no";
		serviceConfig.Type = "oneshot";

		path = [ pkgs.findutils ];
		script = ''
			echo "The following files will be deleted:"
			find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup"
			find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup" -delete
		'';
	};

	system.userActivationScripts.backupRemove = ''
		find ${config.users.users.${host.user}.home} -type f -name "*.hmBackup" -delete
	'';

}
