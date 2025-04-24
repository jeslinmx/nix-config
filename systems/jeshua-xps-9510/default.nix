{
  inputs,
  nixosModules,
  homeModules,
  ...
}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules) interactive-common quirks-iwlwifi quirks-gmk67 extra-cloudflare-warp extra-containers extra-java extra-ollama extra-secure-boot extra-virtualisation extra-zerotier;
    inherit (inputs.nixos-hardware.nixosModules) dell-xps-15-9510 dell-xps-15-9510-nvidia;
    inherit (inputs.lanzaboote.nixosModules) lanzaboote;
  };
  config = {
    system.stateVersion = "24.05";
    networking.hostName = "jeshua-xps-9510";

    ### BOOT CUSTOMIZATION ###
    boot.initrd = {
      availableKernelModules = ["xhci_pci" "nvme"];
      kernelModules = ["dm-snapshot"];
      luks.devices."speqtral".device = "/dev/disk/by-partlabel/speqtral-luks";
    };
    boot.kernelModules = ["kvm-intel"];
    fileSystems = {
      "/" = {
        device = "/dev/speqtral/nixos";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-partlabel/speqtral-boot";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };
    };
    swapDevices = [{device = "/dev/speqtral/swap";}];

    ### ENVIRONMENT CUSTOMIZATION ###
    hardware.nvidia.open = false; # currently broken
    nixpkgs.config.cudaSupport = true;
    stylix = {
      targets.plymouth = {
        logo = "${(pkgs.fetchgit {
            url = "https://github.com/speqtral/branding";
            rev = "95229a6373635d3826b8ba4ed22986c6aa906712";
            hash = "sha256-cVZ93CA6WdWWHMxx64ZzpqSAzO4WmUH4RXmgw51341w=";
            sparseCheckout = ["logos/symbol"];
          })
          .outPath}/logos/symbol/light.png";
        logoAnimated = false;
      };
    };
    programs.openvpn3.enable = true;

    ### USER SETUP ###
    hmUsers.jeslinmx = {
      uid = 1000;
      description = "Jeshua Lin";
      extraGroups = ["wheel" "podman" "libvirtd" "wireshark"];
      openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
      hmModules =
        (builtins.attrValues {
          inherit
            (homeModules)
            aesthetics
            cli-programs
            gui-programs
            hyprland
            xdg
            ;
          inherit
            (inputs.private-config.homeModules)
            awscli
            ssh-personal-hosts
            ssh-speqtral-hosts
            ;
        })
        ++ [
          {
            services = {
              syncthing.enable = true;
              flatpak.packages = [
                "us.zoom.Zoom"
                "md.obsidian.Obsidian"
                "org.godotengine.Godot"
                "net.lutris.Lutris"
                "com.valvesoftware.Steam"
                "io.itch.itch"
                "dev.vencord.Vesktop"
              ];
            };

            home.packages = builtins.attrValues {
              inherit
                (pkgs)
                powershell
                wimlib
                openssl
                ;
            };
          }
        ];
    };
  };
}
