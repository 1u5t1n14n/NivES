{ host, ... }:

{

	imports = [
		./ankiSyncServer.nix
		./dashboard.nix
		./dns.nix
		./gitea.nix
		./gitlab.nix
		./immich.nix
		./jellyfin.nix
		./mollySocket.nix
		./nextCloud.nix
		./nginx.nix
		./ntfy.nix
		./openCloud.nix
		./paperless.nix
		./rss.nix
	];

	environment.persistence."/persist".users.${host.user}.directories = [ "Persist" ];

}
