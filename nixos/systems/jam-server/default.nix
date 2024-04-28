{
  nixosModules,
  nixos-unstable,
  nixos-hardware,
  lanzaboote,
  home-configs,
  ...
} @ inputs:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({lib, pkgs, ...}: {
      imports = with nixosModules; [
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-cpu-intel

        ### SETTINGS ###
        ./hardware-configuration.nix
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        sudo-disable-timeout

        ### FEATURES ###
        console
        docker

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        (home-configs.setup-module "unstable" {
          jeslinmx = {
            uid = 1000;
            extraGroups = ["wheel" "scanner" "lp" "docker"];
            matchHmUsername = false;
            hmCfg = {homeModules, pkgs, ...}: {
              imports = with homeModules; [
                cli-programs
              ];
            };
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jam-server";
      nixpkgs.config.allowUnfree = true;
      nix.settings.trusted-users = [ "@wheel" ];

      ### BOOT CUSTOMIZATION ###
      boot.loader.timeout = 0;

      ### ENVIRONMENT CUSTOMIZATION ###
      services.openssh.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
    })
  ];
}
