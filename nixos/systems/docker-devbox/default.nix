{ flake, lib, ... }: {
  imports = builtins.attrValues {
    inherit (flake.nixosModules) base-common interactive-stylix extra-containers extra-zerotier;
    inherit (flake.inputs.nixos-generators.nixosModules) proxmox-lxc;
  };

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
  stylix.image = ../jeshua-xps-9510/wallpaper.jpg;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    liveRestore = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  virtualisation.podman.enable = lib.mkForce false;

### USER SETUP ###
  hmUsers.jeslinmx = {
    uid = 1000;
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
    hmModules = [ flake.homeModules.cli-programs ];
  };

}
