{
  inputs,
  nixosModules,
  ...
}: {lib, ...}: {
  imports =
    builtins.attrValues {
      inherit (nixosModules) base-common extra-zerotier;
      inherit (inputs.nixos-generators.nixosModules) proxmox-lxc;
    }
    ++ [
      ./proxy.nix
      ./restic.nix
      ./flood.nix
      ./gitea.nix
      ./silverbullet.nix
      ./syncthing.nix
      ./netdata.nix
      ./docker-registry.nix
      ./zerotier-coredns.nix
    ];

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = inputs.private-config.ssh-authorized-keys;
}
