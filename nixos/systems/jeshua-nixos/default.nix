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

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        (home-configs.setup-module "unstable" {
          jeslinmx = {
            uid = 1000;
            description = "Jeshy";
            extraGroups = ["wheel" "scanner" "lp"];
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
      services.flatpak.enable = true;
      virtualisation.libvirtd.enable = true;
      environment.sessionVariables = {GDK_SCALE = "1.5";};
      boot.supportedFilesystems = ["ntfs"];
      boot.kernel.sysctl = {"vm.swappiness" = 0;};

      ### USER SETUP ###
      users.defaultUserShell = pkgs.bashInteractive;
    })
  ];
}
