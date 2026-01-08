{ lib, ... }:

let
	mountOptions = {
		mountpoint = "legacy";
		atime = "off";
		"com.sun:auto-snapshot" = builtins.toString false;
	};

in
{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = lib.mkDefault "/dev/nvme0n1";
				content = {
					type = "gpt";
					partitions = {
						boot = {
							size = "512M";
							type = "EF00";
							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/boot";
								mountOptions = [ "umask=0077" ];
							};
						};

						swap = {
							size = "16G";
							content = {
								type = "swap";
								randomEncryption = true;
								priority = 100;
							};
						};

						root = {
							size = "100%";
							content = {
								name = "luks";
								type = "luks";
								passwordFile = "/tmp/passwordfile";
								additionalKeyFiles = [ "/tmp/keyfile" ];
								settings = {
									allowDiscards = true;
									fallbackToPassword = true;
									keyFile = "/dev/sda";
									keyFileSize = 4096;

									# For SystemD
									# keyFileTimeout = 2;
								};
								content = {
									type = "zfs";
									pool = "zroot";
								};
							};
						};
					};
				};
			};
		};

		zpool = {
			zroot = {
				type = "zpool";
				rootFsOptions = {
					compression = "zstd";
					"com.sun:auto-snapshot" = builtins.toString false;
					mountpoint = "none";
				};
				mountpoint = "/";
				postCreateHook = ''
					zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank
				'';

				datasets = {
					root = {
						type = "zfs_fs";
						options = mountOptions;
						mountpoint = "/";
						postCreateHook = lib.mkIf false ''
							zfs snapshot zroot/root@blank
						'';
					};
					nix = {
						type = "zfs_fs";
						options = mountOptions;
						mountpoint = "/nix";
						postCreateHook = lib.mkIf false ''
							zfs snapshot zroot/nix@blank
						'';
					};
					persist = {
						type = "zfs_fs";
						options = mountOptions;
						mountpoint = "/persist";
						postCreateHook = lib.mkIf false ''
							zfs snapshot zroot/persist@blank
						'';
					};
				};
			};
		};
	};

	fileSystems."/persist".neededForBoot = true;
}
