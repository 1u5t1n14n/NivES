{ host, ... }:

{

	imports = [
		./jellyfin.nix
		./ankiSyncServer.nix
		./dashboard.nix
		./dns.nix
		./gitea.nix
		./immich.nix
		./nextCloud.nix
		./gitlab.nix
		./nginx.nix
		./ntfy.nix
		./openCloud.nix
		./paperless.nix
	];

	environment.persistence."/persist".users.${host.user}.directories = [ "Persist" ];

}
