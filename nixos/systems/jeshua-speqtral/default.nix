{
  nixosModules,
  nixos-2311,
  nixos-hardware,
  lanzaboote,
  home-configs,
  ...
}:
nixos-2311.lib.nixosSystem {
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
        # plymouth
        power-management
        quirks-iwlwifi
        sudo-disable-timeout

        ### FEATURES ###
        chinese-input
        cloudflare-warp
        enable-via-qmk
        gnome
        ios-usb
        windows-fonts
        wireshark

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        (home-configs.setup-module "23.11" {
          jeshua = {
            uid = 1000;
            description = "Jeshua Lin";
            extraGroups = ["wheel" "scanner" "lp" "wireshark"];
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-speqtral";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot.netbootxyz.enable = true;
      };

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
