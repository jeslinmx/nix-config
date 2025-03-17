{
  flake,
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (flake.nixosModules) base-common interactive-stylix extra-containers extra-zerotier;
    # inherit (flake.inputs.nixos-generators.nixosModules) proxmox-lxc;
  };

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  virtualisation.podman.enable = lib.mkForce false;
  environment.systemPackages = [pkgs.lazydocker];

  ### USER SETUP ###
  hmUsers.jeslinmx = {
    uid = 1000;
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
    hmModules = [flake.homeModules.cli-programs];
  };
}
