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
    zerotier
    ;
  }) ++ [
    nixos-generators.nixosModules.proxmox-lxc
    ({ lib, pkgs, ...}: {
      system.stateVersion = "24.05";
      networking.hostName = "mc-server";
      nixpkgs.config.allowUnfree = true;
      nix.settings.trusted-users = [ "@wheel" ];

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      hmUsers.jeslinmx = {
        uid = 1000;
        extraGroups = ["wheel" "scanner" "lp" "docker"];
        openssh.authorizedKeys.keys = private-config.ssh-authorized-keys;
        hmModules = [ flake.homeModules.cli-programs ];
      };

      ### ENVIRONMENT SETUP ###
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
