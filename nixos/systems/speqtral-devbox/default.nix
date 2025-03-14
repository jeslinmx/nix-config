{
  flake,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (flake.nixosModules) base-common interactive-stylix extra-containers extra-zerotier;
    inherit (flake.inputs.nixos-generators.nixosModules) proxmox-lxc;
  };

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  # temp:
  networking.hosts = {"10.1.128.13" = ["nqsnplus-sw-testbed.speqtranet.com"];};

  ### USER SETUP ###
  hmUsers.jeslinmx = {
    uid = 1000;
    extraGroups = ["wheel" "podman" "wireshark"];
    openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
    hmModules =
      (builtins.attrValues {
        inherit
          (flake.homeModules)
          cli-programs
          ;
        inherit
          (flake.inputs.private-config.homeModules)
          awscli
          ssh-speqtral-hosts
          ;
      })
      ++ [
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              powershell
              wimlib
              ;
          };
        }
      ];
  };
}
