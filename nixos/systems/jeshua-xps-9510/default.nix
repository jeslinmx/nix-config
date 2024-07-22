{
  self,
  nixosModules,
  nixpkgs,
  nixos-hardware,
  lanzaboote,
  mkHmUsers,
  ...
} @ inputs:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = (builtins.attrValues { inherit (nixosModules)
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
    nixos-hardware.nixosModules.dell-xps-15-9510
    nixos-hardware.nixosModules.dell-xps-15-9510-nvidia
    lanzaboote.nixosModules.lanzaboote
    ({pkgs, config, ...}: {
      system.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot = {
        initrd = {
          availableKernelModules = [ "xhci_pci" "nvme" ];
          kernelModules = [ "dm-snapshot" ];
          luks.devices."speqtral".device = "/dev/disk/by-partlabel/speqtral-luks";
        };
        kernelModules = [ "kvm-intel" ];
      };
      system.nixos.label = "${config.networking.hostName}:${toString (self.shortRev or self.dirtyShortRev or self.lastModified or "(unknown rev)")}";

      fileSystems."/" =
        { device = "/dev/speqtral/nixos";
          fsType = "ext4";
        };

      fileSystems."/boot" =
        { device = "/dev/disk/by-partlabel/speqtral-boot";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

      swapDevices =
        [ { device = "/dev/speqtral/swap"; }
        ];

      ### ENVIRONMENT CUSTOMIZATION ###
      nixpkgs.hostPlatform = "x86_64-linux";
      hardware.enableRedistributableFirmware = true;
      hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      services.flatpak.enable = true;
      programs.wireshark.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
    })

    ### jeshua-nixos specialisation ###
    {
      specialisation.personal.configuration = {
        imports = [
          nixosModules.steam
          nixosModules.zerotier
          (mkHmUsers {
            jeslinmx = {
              uid = 1000;
              description = "Jeshy";
              extraGroups = ["wheel" "scanner" "lp" "podman" "libvirtd" "wireshark"];
            };
          })
        ];
        networking.hostName = "jeshua-nixos";
        boot.initrd.luks.devices."personal".device = "/dev/disk/by-partlabel/personal-luks";
        fileSystems."/home" =
          { device = "/dev/personal/home";
          fsType = "ext4";
        };
        stylix.image = ./wallpaper.jpg;
      };
    }

    ### jeshua-speqtral specialisation ###
    ({ pkgs, ... }: {
      specialisation.speqtral.configuration = {
        imports = [
          (mkHmUsers {
            jeshua = {
              uid = 1000;
              description = "Jeshua Lin";
              extraGroups = ["wheel" "scanner" "lp" "wireshark"];
              hmCfg = {homeModules, private-config, pkgs, ...}: {
                imports = (builtins.attrValues { inherit (homeModules)
                aesthetics
                cli-programs
                gui-programs
                gnome-shell
                termshark
                ;}) ++ (builtins.attrValues { inherit (private-config.homeModules)
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
        networking.hostName = "jeshua-speqtral";
        stylix = {
          image = ./speqtral.png;
          targets.plymouth = {
            logo = "${(pkgs.fetchFromGitHub {
              owner = "speqtral";
              repo = "branding";
              rev = "95229a6373635d3826b8ba4ed22986c6aa906712";
              hash = "sha256-gGq5VS0YvRM4HPJkXLC3pSQANyjIdEwn1jjFINg15yY=";
            }).outPath}/logos/symbol/light.png";
            logoAnimated = false;
          };
        };
      };
    })
  ];
}
