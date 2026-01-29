{ host, ... }:

{

	imports = [
		./ankiSyncServer.nix
		./dashboard.nix
		./dns.nix
		./gitea.nix
		./immich.nix
		./nextCloud.nix
		./openCloud.nix
		./paperless.nix
		./ntfy.nix
	];

	environment.persistence."/persist".users.${host.user}.directories = [ "Persist" ];

}
