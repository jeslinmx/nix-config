flake: let inherit (flake.inputs) nixpkgs nixos-generators private-config;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit flake; };
  modules = (builtins.attrValues { inherit (flake.nixosModules)
    ### SETTINGS ###
    locale-sg
    nix-enable-flakes
    nix-gc

    ### FEATURES ###
    sshd
    zerotier
    ;
  }) ++ [
    nixos-generators.nixosModules.proxmox-lxc
    ({ lib, pkgs, ...}: {
      system.stateVersion = "24.05";
      networking.hostName = "app-server";
      nixpkgs.config.allowUnfree = true;

      ### ENVIRONMENT SETUP ###
      services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
      users.users.root.openssh.authorizedKeys.keys = private-config.ssh-authorized-keys;
    })

    ### SERVICES ###
    ./silverbullet.nix
    ./syncthing.nix
    ./zerotier-coredns.nix
  ];
}
