{ host, ... }:

{

	imports = [
		./ankiSyncServer.nix
		./dashboard.nix
		./dns.nix
		./immich.nix
		./nextCloud.nix
		./openCloud.nix
		./paperless.nix
	];

	environment.persistence."/persist".users.${host.user}.directories = [
		"Persist"
	];

}
