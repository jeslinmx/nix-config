flake: let inherit (flake.inputs) nixpkgs nixos-generators private-config;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit flake; };
  modules = (builtins.attrValues { inherit (flake.nixosModules)
    ### SETTINGS ###
    locale-sg
    nix-enable-flakes
    nix-gc
    sudo-disable-timeout

    ### FEATURES ###
    containers
    home-manager-users
    sshd
    stylix
    zerotier
    ;
  }) ++ [
    nixos-generators.nixosModules.proxmox-lxc
    ({ lib, pkgs, ...}: {
      system.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;
      nix.settings.trusted-users = [ "@wheel" ];

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      hmUsers.jeslinmx = {
        uid = 1000;
        extraGroups = ["wheel" "docker"];
        openssh.authorizedKeys.keys = private-config.ssh-authorized-keys;
        hmModules = [ flake.homeModules.cli-programs ];
      };

      ### ENVIRONMENT SETUP ###
      # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
      stylix.image = ../jeshua-xps-9510/wallpaper.jpg;
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        liveRestore = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
      virtualisation.podman.enable = lib.mkForce false;
    })
  ];
}
