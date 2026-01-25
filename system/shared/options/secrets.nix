{ lib, ... }:

{

	options.extra = {
		secretsEnabled = lib.mkEnableOption "Whether Secrets via Sops are in Place.";
	};

}
