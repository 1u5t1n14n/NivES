{ config, lib, pkgs, ... }:

{

	environment = {
		etc.nixPkgs.text =
			let
				packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
				sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
			in
				builtins.concatStringsSep "\n" sortedUnique;
	};

}
