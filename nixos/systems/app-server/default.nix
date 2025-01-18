{
  flake,
  lib,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit (flake.nixosModules) base-common extra-zerotier;
      inherit (flake.inputs.nixos-generators.nixosModules) proxmox-lxc;
    }
    ++ [
      ./proxy.nix
      ./restic.nix
      ./flood.nix
      ./silverbullet.nix
      ./syncthing.nix
      ./couchdb.nix
      ./docker-registry.nix
      ./zerotier-coredns.nix
    ];

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
}
