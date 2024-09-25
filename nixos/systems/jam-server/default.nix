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
    sudo-disable-timeout

    ### FEATURES ###
    console
    containers
    home-manager-users
    secure-boot
    sshd
    syncthing-server
    systemd-boot
    zerotier
    zerotier-coredns
    ;
    inherit (nixos-hardware.nixosModules) common-pc common-pc-ssd common-cpu-intel;
    inherit (lanzaboote.nixosModules) lanzaboote;
  }) ++ [
    ./hardware-configuration.nix
    ({ lib, pkgs, ...}: {
      system.stateVersion = "23.11";
      networking.hostName = "jam-server";
      nixpkgs.config.allowUnfree = true;
      nix.settings.trusted-users = [ "@wheel" ];

      ### BOOT CUSTOMIZATION ###
      boot.loader.timeout = 0;

      ### ENVIRONMENT SETUP ###
      age.secrets.zt_token.file = ./zt_token.age;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      hmUsers.jeslinmx = {
        uid = 1000;
        extraGroups = ["wheel" "scanner" "lp" "podman"];
          openssh.authorizedKeys.keys = lib.splitString "\n" ( lib.readFile ( pkgs.fetchurl {
              url = "https://github.com/jeslinmx.keys";
              hash = "sha256-iMuMcvz+q3BPKtsv0ZXBzy6Eps4uh9Fj7z92wdONZq4=";
          }));
        hmModules = [ flake.homeModules.cli-programs ];
      };
    })

    ### SERVICES ###
    ./silverbullet.nix
  ];
}
