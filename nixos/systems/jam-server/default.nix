{
  nixosModules,
  nixos-unstable,
  nixos-hardware,
  lanzaboote,
  setup-hm,
  ...
} @ inputs:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({ pkgs, ...}: {
      imports = (builtins.attrValues { inherit (nixosModules)
        ### SETTINGS ###
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        sudo-disable-timeout

        ### FEATURES ###
        console
        containers
        secure-boot
        syncthing-server
        zerotier
      ;}) ++ [
        ./hardware-configuration.nix
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-cpu-intel
        lanzaboote.nixosModules.lanzaboote
        (setup-hm "unstable" {
          jeslinmx = {
            uid = 1000;
            extraGroups = ["wheel" "scanner" "lp" "podman"];
            matchHmUsername = false;
            hmCfg = {homeModules, ...}: {
              imports = [ homeModules.cli-programs ];
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
      services = {
        openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
          };
        };
      };

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
    })
  ];
}
