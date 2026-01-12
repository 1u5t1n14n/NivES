{
	description = ''
		A very basic flake
	'';

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		disko = {
			url = "github:nix-community/disko/latest";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		homeManager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixVim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v1.0.0";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops.url = "github:Mic92/sops-nix";
		impermanence.url = "github:nix-community/impermanence";
		niri.url = "github:sodiboo/niri-flake";

		vicinae.url = "github:vicinaehq/vicinae";
		vicinaeExtensions = {
			url = "github:vicinaehq/extensions";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, ... }@inputs:

	let
		mkNixosConfig = { host }:
			nixpkgs.lib.nixosSystem {
				specialArgs = { inherit host inputs; };
				modules = [
					./system/config.nix

					inputs.disko.nixosModules.disko
					./disko.nix

					inputs.sops.nixosModules.sops
					inputs.impermanence.nixosModules.impermanence
					inputs.lanzaboote.nixosModules.lanzaboote

					inputs.homeManager.nixosModules.home-manager {
						home-manager = {
								extraSpecialArgs = {
									inherit host inputs;
								};
							backupFileExtension = "hmBackup";

							useUserPackages = false;
							useGlobalPkgs = true;
							users.${host.user}.imports = [
								./home/config.nix

								inputs.niri.homeModules.niri
								inputs.vicinae.homeManagerModules.default
								inputs.nixVim.homeModules.nixvim
							];
						};
					}
				];
			};

	in
	{
			nixosConfigurations = {
				Hypnos = mkNixosConfig {
					host = {
						name = "Hypnos";
						user = "1u5t1n14n";
						desktop = false;
					};
				};
				Morpheus = mkNixosConfig {
					host = {
						name = "Morpheus";
						user = "1u5t1n14n";
						desktop = true;
					};
				};
			};
	};
}
