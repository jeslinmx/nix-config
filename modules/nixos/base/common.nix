flake @ {nixosModules, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit
      (nixosModules)
      base-home-manager-users
      base-locale-sg
      base-nix-config
      base-power-management
      base-sshd
      base-sudo
      base-systemd-boot
      ;
  };
  config = lib.mkOverride 900 {
    system.nixos.label = "${config.networking.hostName}-${toString (flake.shortRev or flake.dirtyShortRev or flake.lastModified or "(unknown rev)")}";
    nixpkgs.config.allowUnfree = true;
    hardware = {
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
    users.defaultUserShell = pkgs.fish;
    programs = {
      fish.enable = true;
      wireshark.enable = true;
    };
  };
}
