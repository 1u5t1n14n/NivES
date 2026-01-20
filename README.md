## Structure

```
.
├── home                # Home-Manager configuration
│   ├── firefox
│   ├── gnome
│   ├── niri
│   └── nixvim              # NixVim implementation for NeoVim
└── system
    ├── hosts           # Host specific config files
    └── shared          # Shared configuration between all hosts
        ├── desktop
        ├── options         # Options for NixOS configuration itself
        └── server
```

Every directory contains either a `default.nix` file that pulls in all children
or a `config.nix` file that pulls in the configured directories.

## Installation

> Disclaimer
>
> This guide is not meant to be secure. I only write this for fun and to have a
> guide for myself later. Do not attempt this if you have no idea what any of
> this means!
>
> Also this guide works best when using root so be sure to `sudo -i` yourself.

### Partitioning

You should first connect to the internet.

To obtain the required disko configuration file, either clone this repository
or `curl` it.

You will need to change the disko disk configuration to make it work with your
device. Simply replace `/dev/nvme0n1` in `disko.nix` with your disk device that
is to be partitioned if you have not got a `nvme` drive.

```nix
{
    disko.devices = {
        disk = {
            main = {
                ...
                device = lib.mkDefault "/dev/<Your-Device>";
                ...
            };
        };
        ...
    };
}
```

This configuration configures a LUKS encrypted drive. You will have to put a
plain-text file that contains your preferred passphrase at `/tmp/passwordFile`.

Now, you can run the flake provided by
[nix-community/disko](https://github.com/nix-community/disko). You will need
to accept the partitioning by typing `yes` at some point.

```bash
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- -m destroy,format,mount disko.nix
```

### `nixos-install`

You will need to scan your hardware manually by running following command.

```bash
nixos-generate-config --root /mnt --no-filesystems
```

> The `--no-filesystems` flag is only necessary if you plan to use the
> resulting `hardware-configuration.nix` file without disko.

You have to copy the resulting hardware configuration relatively to
`./system/hosts/<Your-Hostname>.nix`. For implementing impermanence, you will
need to enable `environment.persistence."/persist"` manually because it is
disabled by default. Then, simply add a new entry in `flake.nix`.

```nix
{
    ...

    inputs = { ... };

    outputs = { self, nixpkgs, ... }@inputs:

    ...

    {
        nixosConfigurations = {
            <Your-Hostname> = mkNixosConfig {
                host = {
                    name = "<Your-Hostname>";
                    user = "<Your-Main-Username>";

                    # Whether graphical progams and a desktop environment
                    # should be configured.
                    desktop = true;
                };
            };
        };
    };
}
```

Just hit `nixos-install` and sit back.

```bash
nixos-install --root /mnt --flake .#<Your-Hostname>
```
