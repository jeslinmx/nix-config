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
    sunshine
    systemd-boot
    virtualisation
    windows-fonts
    zerotier
    ;
    inherit (nixos-hardware.nixosModules) common-cpu-intel common-pc-laptop common-pc-laptop-ssd;
    inherit (lanzaboote.nixosModules) lanzaboote;
  }) ++ [
    ({lib, pkgs, config, ...}: {
      system.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;
      networking.hostName = "jeshua-inspiron";

      ### BOOT CUSTOMIZATION ###
      boot = {
        initrd = {
          availableKernelModules = [ "xhci_pci" "nvme" ];
          kernelModules = [ "dm-snapshot" ];
          luks.devices."primary".device = "/dev/disk/by-partlabel/primary-luks";
        };
        kernelModules = [ "kvm-intel" ];
      };
      system.nixos.label = "${config.networking.hostName}:${toString (flake.shortRev or flake.dirtyShortRev or flake.lastModified or "(unknown rev)")}";

      fileSystems = {
        "/" = {
          device = "/dev/primary/nixos";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-partlabel/esp";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };
      };

      swapDevices = [ { device = "/dev/primary/swap"; } ];

      ### ENVIRONMENT CUSTOMIZATION ###
      nixpkgs.hostPlatform = "x86_64-linux";
      hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      };
      services.flatpak.enable = true;
      services.openssh.listenAddresses = [ { addr = "192.168.222.51"; } ];
      programs.wireshark.enable = true;
      stylix.image = ./wallpaper.jpg;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
        hmUsers.jeslinmx = {
          uid = 1000;
          description = "Jeshy";
          extraGroups = ["wheel" "scanner" "lp" "podman" "libvirtd" "wireshark"];
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
          ; inherit (flake.inputs.private-config.homeModules)
            ssh-personal-hosts
          ;}) ++ [{
            xdg.enable = true;

            services = {
              syncthing.enable = true;
              flatpak.packages = [
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
    })
  ];
}
