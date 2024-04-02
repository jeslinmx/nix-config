{
  nixosModules,
  nixos-unstable,
  nixos-hardware,
  lanzaboote,
  home-configs,
  ...
}:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ({pkgs, ...}: {
      imports = with nixosModules; [
        nixos-hardware.nixosModules.dell-xps-15-9510
        nixos-hardware.nixosModules.dell-xps-15-9510-nvidia

        ### SETTINGS ###
        ./hardware-configuration.nix
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        power-management
        quirks-iwlwifi
        sudo-disable-timeout

        ### FEATURES ###
        chinese-input
        cloudflare-warp
        enable-via-qmk
        gnome
        ios-usb
        steam
        windows-fonts
        docker

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        (home-configs.setup-module "unstable" {
          jeslinmx = {
            uid = 1000;
            description = "Jeshy";
            extraGroups = ["wheel" "scanner" "lp" "docker"];
          };
        })
      ];

      system.stateVersion = "23.05";
      networking.hostName = "jeshua-nixos";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot.netbootxyz.enable = true;
      };
      boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/4931d933-81f1-45c3-87b5-6944e52703fd";

      ### ENVIRONMENT CUSTOMIZATION ###
      virtualisation.libvirtd.enable = true;
      services = {
        flatpak.enable = true;
        fprintd.enable = true;
      };

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
    })
  ];
}
