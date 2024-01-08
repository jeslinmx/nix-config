# Setting up a new system

1. [Set up partitions on device](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning)
2. [Mount partitions under /mnt (and swapon any swap partitions)](https://nixos.org/manual/nixos/stable/#sec-installation-manual-installing)
3. `nixos-generate-config --root /mnt`
4. Copy /mnt/etc/nixos/hardware-configuration.nix to ./nixos/<hostname>/
5. Write nixos/<hostname>/configuration.nix
6. `nixos-install --flake .#<hostname> --root /mnt`
7. If using Secure Boot, perform the steps described in ./nixos/common/secure-boot.nix, making sure to `nixos-enter` before running any commands
8. Reboot into the new system
9. Symlink /etc/nixos/flake.nix to a local copy of ./flake.nix

# Updating an existing system

```bash
nix flake update
nixos-rebuild switch
```
