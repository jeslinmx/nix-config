{inputs, ...}: {
  config,
  lib,
  ...
}: {
  imports = [inputs.home-manager.darwinModules.home-manager];

  options = let
    inherit (lib) types mkOption;
  in {
    hmUsers = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };

  config = let
    cfg = config.hmUsers;
  in {
    users = {
      users = lib.mkMerge (lib.mapAttrsToList (
          username: userCfg: {
            ${username} =
              {home = lib.mkDefault "/Users/${username}";}
              // (lib.filterAttrs (k: _: !(builtins.elem k ["hmModules"])) userCfg);
          }
        )
        cfg);
      knownUsers = builtins.attrNames cfg;
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hmbak";
      users =
        lib.mapAttrs (
          username: {hmModules ? [], ...}: {
            imports = let
              defaultModules = [
                ({osConfig, ...}: {
                  # home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
                  home.homeDirectory = lib.mkDefault "/Users/${username}";
                })
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
