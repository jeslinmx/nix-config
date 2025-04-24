{
  inputs,
  nixosModules,
  homeModules,
  ...
}: {
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules) base-common interactive-stylix extra-containers extra-zerotier;
    # inherit (inputs.nixos-generators.nixosModules) proxmox-lxc;
  };

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  virtualisation.podman.enable = lib.mkForce false;
  environment.systemPackages = [pkgs.lazydocker];

  ### USER SETUP ###
  hmUsers.jeslinmx = {
    uid = 1000;
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
    hmModules = [homeModules.cli-programs];
  };
}
