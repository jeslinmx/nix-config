{ flake, lib, config, pkgs, ... }: {
  imports = (builtins.attrValues {
    inherit (flake.nixosModules) interactive-common quirks-iwlwifi quirks-gmk67 extra-cloudflare-warp extra-containers extra-java extra-secure-boot extra-virtualisation extra-zerotier;
    inherit (flake.inputs.nixos-hardware.nixosModules) dell-xps-15-9510 dell-xps-15-9510-nvidia;
    inherit (flake.inputs.lanzaboote.nixosModules) lanzaboote;
  });
  config = lib.mkMerge [{
    system.stateVersion = "24.05";

    ### BOOT CUSTOMIZATION ###
    boot.initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."speqtral".device = "/dev/disk/by-partlabel/speqtral-luks";
    };
    boot.kernelModules = [ "kvm-intel" ];
    fileSystems = {
      "/" = { device = "/dev/speqtral/nixos"; fsType = "ext4"; };
      "/boot" = {
        device = "/dev/disk/by-partlabel/speqtral-boot";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    };
    swapDevices = [ { device = "/dev/speqtral/swap"; } ];

    ### ENVIRONMENT CUSTOMIZATION ###
    hardware.nvidia.open = false; # currently broken
  }

  ### jeshua-nixos specialisation ###
  { specialisation.personal.configuration = {
    networking.hostName = "jeshua-nixos";
    ### BOOT CUSTOMIZATION ###
    boot.initrd.luks.devices."personal".device = "/dev/disk/by-partlabel/personal-luks";
    fileSystems."/home" = { device = "/dev/personal/home"; fsType = "ext4"; };
    ### ENVIRONMENT CUSTOMIZATION ###
    services.openssh.listenAddresses = [ { addr = "192.168.222.51"; } ];
    # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
    stylix.image = ./wallpaper.jpg;

    ### USER SETUP ###
    hmUsers.jeslinmx = {
      uid = 1000;
      description = "Jeshy";
      extraGroups = ["wheel" "podman" "libvirtd" "wireshark"];
      openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
      hmModules = (builtins.attrValues { inherit (flake.homeModules)
        aesthetics
        cli-programs
        gui-programs
        gnome-shell
        hyprland
      ; inherit (flake.inputs.private-config.homeModules)
        ssh-personal-hosts
        ssh-speqtral-hosts
      ;}) ++ [{
        xdg.enable = true;

        services = {
          syncthing.enable = true;
          flatpak.packages = [
            "md.obsidian.Obsidian"
            "de.haeckerfelix.Fragments"
            "org.godotengine.Godot"
            "net.lutris.Lutris"
            "com.valvesoftware.Steam"
            "io.itch.itch"
            "org.prismlauncher.PrismLauncher"
            "dev.vencord.Vesktop"
          ];
        };
      }];
    };
    };}

  ### jeshua-speqtral specialisation ###
  (lib.mkIf (config.specialisation != {}) {
    ### ENVIRONMENT CUSTOMIZATION ###
    networking.hostName = "jeshua-speqtral";
    services.openssh.authorizedKeysInHomedir = lib.mkForce true;
    stylix = {
      image = ./speqtral.png;
      targets.plymouth = {
        logo = "${(pkgs.fetchgit {
          url = "https://github.com/speqtral/branding";
          rev = "95229a6373635d3826b8ba4ed22986c6aa906712";
          hash = "sha256-cVZ93CA6WdWWHMxx64ZzpqSAzO4WmUH4RXmgw51341w=";
          sparseCheckout = ["logos/symbol"];
        }).outPath}/logos/symbol/light.png";
        logoAnimated = false;
      };
    };

    ### USER SETUP ###
    hmUsers.jeslinmx = {
      uid = 1000;
      description = "Jeshua Lin";
      extraGroups = ["wheel" "podman" "libvirtd" "wireshark"];
      openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
      hmModules = (builtins.attrValues { inherit (flake.homeModules)
        aesthetics
        cli-programs
        gui-programs
        gnome-shell
        hyprland
      ; inherit (flake.inputs.private-config.homeModules)
        awscli
        ssh-speqtral-hosts
      ;}) ++ [{
        xdg.enable = true;

        services = {
          syncthing.enable = true;
          flatpak.packages = [
            "us.zoom.Zoom"
            "com.jgraph.drawio.desktop"
          ];
        };

        home.packages = builtins.attrValues { inherit (pkgs)
          powershell
          wimlib
          openssl
          ciscoPacketTracer8
        ;};
      }];
    };
  })
  ];
}
