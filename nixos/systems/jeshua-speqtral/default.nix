{
  nixosModules,
  nixos-unstable,
  lanzaboote,
  home-configs,
  ...
}:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ({pkgs, ...}: {
      imports = with nixosModules; [
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

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        standard-users
        (home-configs.setup-module "unstable")
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
      services.flatpak.enable = true;
      virtualisation.libvirtd.enable = true;
      environment.sessionVariables = {GDK_SCALE = "1.5";};

      ### USER SETUP ###
      users.defaultUserShell = pkgs.bashInteractive;
      users.users.jeslinmx = {
        isStandardUser = true;
        description = "Jeshua Lin";
        extraGroups = ["wheel" "scanner" "lp"];
      };
    })
  ];
}
