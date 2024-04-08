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
    ({lib, pkgs, ...}: {
      imports = with nixosModules; [
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-cpu-intel

        ### SETTINGS ###
        ./hardware-configuration.nix
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        sudo-disable-timeout

        ### FEATURES ###
        console
        docker

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jam-server";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.loader.timeout = 0;

      ### ENVIRONMENT CUSTOMIZATION ###
      virtualisation.libvirtd.enable = true;
      services.openssh.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      users.users.jeslinmx = {
        isNormalUser = true;
        extraGroups = ["wheel" "scanner" "lp" "docker"];
        openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
          url = "https://github.com/jeslinmx.keys";
          hash = "sha256-BwgEaDlwJqFyu0CMhKbGK6FTMYfgZCWnS8Arhny66Pg=";
        }).outPath);
      };
    })
  ];
}
