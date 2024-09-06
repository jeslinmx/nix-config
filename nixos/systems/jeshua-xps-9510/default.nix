flake: let inherit (flake.inputs) nixpkgs nixos-hardware lanzaboote;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit flake; };
  modules = (builtins.attrValues { inherit (flake.nixosModules)
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
    home-manager-users
    ios-usb
    java
    sshd
    secure-boot
    stylix
    systemd-boot
    virtualisation
    windows-fonts
    ;
    inherit (nixos-hardware.nixosModules) dell-xps-15-9510 dell-xps-15-9510-nvidia;
    inherit (lanzaboote.nixosModules) lanzaboote;
  }) ++ [
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
      system.nixos.label = "${config.networking.hostName}:${toString (flake.shortRev or flake.dirtyShortRev or flake.lastModified or "(unknown rev)")}";

      fileSystems = {
        "/" =
          { device = "/dev/speqtral/nixos";
          fsType = "ext4";
        };

        "/boot" =
          { device = "/dev/disk/by-partlabel/speqtral-boot";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };
      };

      swapDevices = [ { device = "/dev/speqtral/swap"; } ];

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
    ({ lib, pkgs, ... }: {
      specialisation.personal.configuration = {
        imports = [
          flake.nixosModules.zerotier
        ];
        networking.hostName = "jeshua-nixos";
        boot.initrd.luks.devices."personal".device = "/dev/disk/by-partlabel/personal-luks";
        fileSystems."/home" =
          { device = "/dev/personal/home";
          fsType = "ext4";
        };
        services.openssh.listenAddresses = [ { addr = "192.168.222.51"; } ];
        # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
        stylix.image = ./wallpaper.jpg;

        hmUsers.jeslinmx = {
          uid = 1000;
          description = "Jeshy";
          extraGroups = ["wheel" "scanner" "lp" "podman" "libvirtd" "wireshark"];
          hashedPassword = "$y$j9T$Y1nDY/UdDZ6g//Kz84SaL/$N1pm904Az.rHaZu3GjQHIRY02sAUdUlkq5QaBsenZ.D";
          openssh.authorizedKeys.keys = lib.splitString "\n" ( lib.readFile ( pkgs.fetchurl {
              url = "https://github.com/jeslinmx.keys";
              hash = "sha256-iMuMcvz+q3BPKtsv0ZXBzy6Eps4uh9Fj7z92wdONZq4=";
          }));
          hmModules = (builtins.attrValues { inherit (flake.homeModules)
            aesthetics
            ai
            cli-programs
            gui-programs
            gnome-shell
            termshark
          ; inherit (flake.inputs.private-config.homeModules)
            ssh-personal-hosts
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
      };
    })

    ### jeshua-speqtral specialisation ###
    ({ lib, config, pkgs, ... }: {
      config = lib.mkIf (config.specialisation != {}) {
        networking.hostName = "jeshua-speqtral";
        services.openssh.authorizedKeysInHomedir = lib.mkForce true;
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

        hmUsers.jeshua = {
          uid = 1000;
          description = "Jeshua Lin";
          extraGroups = ["wheel" "scanner" "lp" "podman" "libvirtd" "wireshark"];
          hashedPassword = "$y$j9T$oXg5n5hIIpz9JZG8QvTLr1$MKjw1m695.YQcJeaXcrbIItHaM8FvMYiAz4USTL4Vl1";
          openssh.authorizedKeys.keys = lib.splitString "\n" ( lib.readFile ( pkgs.fetchurl {
              url = "https://github.com/jeslinmx.keys";
              hash = "sha256-iMuMcvz+q3BPKtsv0ZXBzy6Eps4uh9Fj7z92wdONZq4=";
          }));
          hmModules = (builtins.attrValues { inherit (flake.homeModules)
            aesthetics
            cli-programs
            gui-programs
            gnome-shell
            termshark
          ; inherit (flake.inputs.private-config.homeModules)
            awscli
            ssh-speqtral-hosts
          ;}) ++ [{
            xdg.enable = true;

            services = {
              syncthing.enable = true;
              flatpak.packages = [
                "com.github.IsmaelMartinez.teams_for_linux"
                "us.zoom.Zoom"
                "com.jgraph.drawio.desktop"
              ];
            };

            home.packages = builtins.attrValues { inherit (pkgs)
              powershell
              wimlib
              ciscoPacketTracer8
            ;};
          }];
        };
      };
    })
  ];
}
