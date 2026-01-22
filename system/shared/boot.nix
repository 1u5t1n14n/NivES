{ config, pkgs, lib, ... }:

let

	# See <https://wiki.nixos.org/wiki/ZFS> for this wonderful snippet.
	zfsCompatibleKernelPackages = lib.filterAttrs (
		name: kernelPackages: (builtins.match "linux_[0-9]+_[0-9]+" name) != null && (builtins.tryEval kernelPackages).success
			&& (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
	) pkgs.linuxKernel.packages;
	latestKernelPackage = lib.last (
		lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
			builtins.attrValues zfsCompatibleKernelPackages
		)
	);

in
{

	# Secure Boot Setup
	# Currently not working perfectly
	# DO NOT RELY ON THIS.
	environment = {
		systemPackages = [ pkgs.sbctl ];
		persistence."/persist".directories = lib.mkIf config.boot.lanzaboote.enable
			[ config.boot.lanzaboote.pkiBundle ];
	};

	# Already on master, but not currently in flake
	systemd.services = {
		generate-sb-keys = {
			unitConfig.ConditionPathExists = lib.mkForce "!${config.boot.lanzaboote.pkiBundle}/keys";
		};
	};

	boot = {
		lanzaboote = {
			pkiBundle = "/var/lib/sbctl";
			autoGenerateKeys.enable = true;
			autoEnrollKeys = {
				enable = true;
				autoReboot = true;
			};
		};

		kernelPackages = latestKernelPackage;

		consoleLogLevel = 3;
		initrd = {
			luks.devices.luks = {
				keyFile = lib.mkDefault "/dev/sda1";
				keyFileSize = 4096;
				keyFileTimeout = 5;
			};
			kernelModules = lib.mkIf (builtins.elem "usb_storage" config.boot.initrd.availableKernelModules)
				[ "usb_storage" ];

			systemd = {
				enable = true;
				services.zfsRollback = lib.mkIf config.environment.persistence."/persist".enable {
					description = "Roll back to a blank filesystem";

					after = [ "cryptsetup.target" ];
					wantedBy = [ "initrd.target" ];
					before = [ "sysroot.mount" ];

					unitConfig.DefaultDependencies = "no";
					serviceConfig.type = "oneshot";

					path = [ pkgs.zfs ];
					script = ''
						zfs rollback -r zroot@blank
					'';
				};
			};
			verbose = false;

			postResumeCommands = lib.mkIf (!config.boot.initrd.systemd.enable
				&& config.environment.persistence."/persist".enable)
				''
					zfs rollback -r zroot@blank
				'';
		};

		kernelParams = [
			"udev.log_priority=3"
			"rd.systemd.show_status=auto"

			"quiet"
			"splash"

			"boot.shell_on_fail"

			"random.trust_cpu=off"
		];

		loader = {
			systemd-boot.enable = false;
			grub = {
				enable = !config.boot.lanzaboote.enable;
				device = "nodev";
				efiSupport = true;
				zfsSupport = true;
				enableCryptodisk = true;
			};
			efi.canTouchEfiVariables = true;
		};

		plymouth = {
			enable = config.boot.initrd.systemd.enable;

			theme = "square_hud";
			themePackages = with pkgs; [(adi1090x-plymouth-themes.override {
				selected_themes = [ config.boot.plymouth.theme ];
			})];

			logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
		};
	};

}
