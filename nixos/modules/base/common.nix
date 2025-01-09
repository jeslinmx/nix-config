{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager-users.nix
    ./locale-sg.nix
    ./nix-config.nix
    ./power-management.nix
    ./sshd.nix
    ./sudo.nix
    ./systemd-boot.nix
  ];
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
