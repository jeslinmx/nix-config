{
  inputs,
  nixosModules,
  ...
}: {
  lib,
  pkgs,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit
        (nixosModules)
        base-common
        extra-zerotier
        server-proxy
        server-restic
        server-flood
        server-gitea
        server-jellyfin
        server-silverbullet
        server-syncthing
        server-netdata
        server-docker-registry
        server-zerotier-coredns
        ;
      inherit (inputs.nixos-generators.nixosModules) proxmox-lxc;
      inherit (inputs.sops-nix.nixosModules) sops;
    }
    ++ [
    ];

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
  sops.defaultSopsFile = ./secrets.yaml;
}
