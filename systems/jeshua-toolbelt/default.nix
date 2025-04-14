{
  inputs,
  nixosModules,
  homeModules,
  ...
}: {
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules) interactive-common extra-containers;
  };

  networking.hostName = "jeshua-toolbelt";
  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  networking.networkmanager.enable = lib.mkForce false; # https://github.com/nix-community/nixos-generators/issues/281
  services.openssh.settings.PermitRootLogin = lib.mkForce "no"; # override install-iso default
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/e7/wallhaven-e7651w.jpg";
    hash = "sha256-RmrNy9hjIVvN8hfDaFMakTWCV0Ln8e0oBgEo8hZWPyA=";
  };

  ### USER SETUP ###
  hmUsers.nixos = {
    extraGroups = ["podman" "wireshark"];
    openssh.authorizedKeys.keys = inputs.private-config.ssh-authorized-keys;
    hmModules =
      (builtins.attrValues {
        inherit
          (homeModules)
          cli-programs
          kitty
          ;
      })
      ++ [
        {
          xdg.enable = true;
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
