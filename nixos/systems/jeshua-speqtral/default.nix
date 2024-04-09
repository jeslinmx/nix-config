{
  nixosModules,
  nixos-2311,
  nixos-hardware,
  lanzaboote,
  home-configs,
  ...
} @ inputs:
nixos-2311.lib.nixosSystem {
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
        # plymouth
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
            hmCfg = {homeModules, privateHomeModules, pkgs, ...}: {
              imports = with homeModules; [
                aesthetics
                common-programs
                gnome-shell
                colors
                rclone
                privateHomeModules.awscli
                privateHomeModules.ssh-speqtral-hosts
              ];

              colors.scheme = "nord";
              xdg.enable = true;

              programs = {
                vscode.enable = true; # natively handles config sync
              };

              home.packages = with pkgs; [
                powershell
                wimlib
                ciscoPacketTracer8
              ];
            };
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
