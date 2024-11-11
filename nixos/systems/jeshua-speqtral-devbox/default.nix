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
    ({pkgs, ...}: {
      networking.hostName = "jeshua-speqtral-devbox";
      system.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;
      nix.settings.trusted-users = [ "root" "@wheel" ];

      ### ENVIRONMENT CUSTOMIZATION ###
      programs.wireshark.enable = true;
      # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
      stylix.image = ./speqtral.png;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      hmUsers.jeslinmx = {
        uid = 1000;
        extraGroups = ["wheel" "podman" "wireshark"];
        openssh.authorizedKeys.keys = private-config.ssh-authorized-keys;
        hmModules = (builtins.attrValues { inherit (flake.homeModules)
          cli-programs
        ; inherit (flake.inputs.private-config.homeModules)
          awscli
          ssh-speqtral-hosts
        ;}) ++ [{
          home.packages = builtins.attrValues { inherit (pkgs)
            powershell
            wimlib
          ;};
        }];
      };
    })
  ];
}
