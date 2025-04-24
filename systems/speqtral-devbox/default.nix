{
  inputs,
  nixosModules,
  homeModules,
  ...
}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules) base-common interactive-stylix extra-containers extra-zerotier;
    inherit (inputs.nixos-generators.nixosModules) proxmox-lxc;
  };

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  # temp:
  networking.hosts = {"10.1.128.13" = ["nqsnplus-sw-testbed.speqtranet.com"];};

  ### USER SETUP ###
  hmUsers.jeslinmx = {
    uid = 1000;
    extraGroups = ["wheel" "podman" "wireshark"];
    openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
    hmModules =
      (builtins.attrValues {
        inherit
          (homeModules)
          cli-programs
          ;
        inherit
          (inputs.private-config.homeModules)
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
