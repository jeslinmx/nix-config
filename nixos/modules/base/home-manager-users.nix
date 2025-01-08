{
  flake,
  config,
  lib,
  ...
}: let
  cfg = config.hmUsers;
  inherit (flake.inputs) home-manager nix-flatpak;
in {
  imports = [home-manager.nixosModules.home-manager];

  options = let
    inherit (lib) types mkOption;
  in {
    hmUsers = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };

  config = {
    users = {
      mutableUsers = true;
      users = lib.mkMerge (lib.mapAttrsToList (
          username: userCfg: {
            ${username} =
              {
                initialHashedPassword = lib.mkDefault "";
                isNormalUser = lib.mkDefault true;
                group = lib.mkIf config.users.users.${username}.isNormalUser (lib.mkOverride 900 username);
              }
              // (lib.filterAttrs (k: _: !(builtins.elem k ["hmModules"])) userCfg);
          }
        )
        cfg);
      groups = lib.mkMerge (lib.mapAttrsToList (
          username: _: {
            ${username} = lib.mkIf config.users.users.${username}.isNormalUser {};
          }
        )
        cfg);
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {inherit flake;};
      backupFileExtension = "hmbak";
      users =
        lib.mapAttrs (
          username: {hmModules ? [], ...}: {
            imports = let
              defaultModules = [
                ({osConfig, ...}: {
                  home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
                })
                # due to https://github.com/gmodena/nix-flatpak/issues/25
                nix-flatpak.homeManagerModules.nix-flatpak
              ];
              # BUG: due to a weird home-manager quirk, modules defined inline in hmModules (i.e. not given as paths to a Nix file) will not be able to request for pkgs as an argument
              # use pkgs from NixOS scope instead
            in (defaultModules ++ hmModules);
          }
        )
        cfg;
    };
  };
}
