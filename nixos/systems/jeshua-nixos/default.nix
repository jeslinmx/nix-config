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
        console
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

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-nixos";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/881257ae-d2e8-410c-8239-a2c834fba279";

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
