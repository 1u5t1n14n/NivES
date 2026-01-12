{ config, pkgs, lib, ... }:

let

	# See <https://wiki.nixos.org/wiki/ZFS> for this wonderful snippet.
	zfsCompatibleKernelPackages = lib.filterAttrs (
		name: kernelPackages:
			(builtins.match "linux_[0-9]+_[0-9]+" name) != null
			&& (builtins.tryEval kernelPackages).success
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

	boot = {
		lanzaboote = {
			pkiBundle = "/var/lib/sbctl";
			autoGenerateKeys.enable = true;
			autoEnrollKeys = {
				enable = true;

				# You will need to manually reboot
				# the system to setup the secure
				# boot keys.
				autoReboot = false;
			};
		};

		kernelPackages = latestKernelPackage;

		# consoleLogLevel = 3;
		initrd = {
			# verbose = false;
			postResumeCommands = lib.mkAfter ''
				zfs rollback -r zroot@blank
			'';
		};

		kernelParams = [
			"quiet"
			"splash"
			"boot.shell_on_fail"
			"udev.log_priority=3"
			"rd.systemd.show_status=auto"
			"random.trust_cpu=off"
		];

		loader = {
			# timeout = 0;
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};

		plymouth = {
			enable = false;

			theme = "square_hud";
			themePackages = with pkgs; [(adi1090x-plymouth-themes.override {
				selected_themes = [ config.boot.plymouth.theme ];
			})];

			logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
		};
	};

}
