{ flake, lib, ... }: {
  imports = builtins.attrValues { inherit (flake.nixosModules)
    ### SETTINGS ###
    locale-sg
    nix-enable-flakes
    nix-gc

    ### FEATURES ###
    sshd
    zerotier
  ;} ++ [
    flake.inputs.nixos-generators.nixosModules.proxmox-lxc
    ./silverbullet.nix
    ./syncthing.nix
    ./zerotier-coredns.nix
  ];

  system.stateVersion = "24.05";
  networking.hostName = "app-server";
  nixpkgs.config.allowUnfree = true;

  ### ENVIRONMENT SETUP ###
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
}
