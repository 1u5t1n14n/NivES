{ pkgs, ... }:

{

	environment.systemPackages = with pkgs; [
		libreoffice-fresh

		hunspell
		hunspellDicts.de_DE
		hunspellDicts.en_GB-ize
	];

	programs.java.enable = true;

	services.languagetool = {
		enable = false;
		public = false;
		port = 8061;
	};

	# API is
	# http://localhost:port/v2/

}
