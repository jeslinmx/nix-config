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
        steam
        stylix
        virtualisation
        windows-fonts
        zerotier
      ;}) ++ [
        ./hardware-configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-p1
        nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
        lanzaboote.nixosModules.lanzaboote
        (setup-hm "unstable" {
          jeslinmx = {
            uid = 1000;
            description = "Jeshy";
            extraGroups = ["wheel" "scanner" "lp" "podman" "libvirtd"];
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-nixos";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/881257ae-d2e8-410c-8239-a2c834fba279";
      system.nixos.tags = [ config.networking.hostName (toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown")) ];

      ### ENVIRONMENT CUSTOMIZATION ###
      services.flatpak.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      stylix.image = ./wallpaper.jpg;
    })
  ];
}
