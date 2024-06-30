{
  self,
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
    ({pkgs, config, ...}: {
      imports = (builtins.attrValues { inherit (nixosModules)
        ### SETTINGS ###
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        plymouth
        power-management
        quirks-iwlwifi
        sudo-disable-timeout

        ### FEATURES ###
        chinese-input
        cloudflare-warp
        console
        containers
        enable-via-qmk
        gnome
        ios-usb
        secure-boot
        stylix
        virtualisation
        windows-fonts

      ;}) ++ [
        ./hardware-configuration.nix
        nixos-hardware.nixosModules.common-gpu-nvidia
        nixos-hardware.nixosModules.lenovo-thinkpad-p1
        nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
        lanzaboote.nixosModules.lanzaboote
        (setup-hm "unstable" {
          jeshua = {
            uid = 1000;
            description = "Jeshua Lin";
            extraGroups = ["wheel" "scanner" "lp" "wireshark"];
            hmCfg = {homeModules, privateHomeModules, pkgs, ...}: {
              imports = (builtins.attrValues { inherit (homeModules)
                aesthetics
                cli-programs
                gui-programs
                gnome-shell
                termshark
              ;}) ++ (builtins.attrValues { inherit (privateHomeModules)
                awscli
                ssh-speqtral-hosts
              ;});

              xdg.enable = true;

              services = {
                syncthing.enable = true;
              };

              home.packages = builtins.attrValues { inherit (pkgs)
                powershell
                wimlib
                ciscoPacketTracer8
              ;};
            };
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-speqtral";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/f20dd278-e1f7-4044-b452-f8340571270f";
      boot.loader.timeout = 0;
      system.nixos.tags = [ config.networking.hostName (toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown")) ];
      stylix.targets.plymouth = {
        logo = "${(pkgs.fetchFromGitHub {
          owner = "speqtral";
          repo = "branding";
          rev = "95229a6373635d3826b8ba4ed22986c6aa906712";
          hash = "sha256-gGq5VS0YvRM4HPJkXLC3pSQANyjIdEwn1jjFINg15yY=";
        }).outPath}/logos/symbol/light.png";
        logoAnimated = false;
      };

      ### ENVIRONMENT CUSTOMIZATION ###
      services.flatpak.enable = true;
      programs.wireshark.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      stylix.image = ./wallpaper.png;
    })
  ];
}
