{ host, ... }:

{

	imports = [
		./settings.nix
		./search.nix
		./style.nix
		./bookmarks.nix
	];

	programs.firefox = {
		enable = host.desktop;
		profiles.default = {
			isDefault = true;
			name = "default";
			id = 0;
		};
	};

}
