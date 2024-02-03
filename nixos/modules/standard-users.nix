{
  lib,
  config,
  ...
}: {
  options.users.users = with lib;
    mkOption {
      type = with types;
        attrsOf (submodule ({
          name,
          config,
          ...
        }: {
          options.isStandardUser = mkEnableOption "standard user creation (isNormalUser, per-user group)";
          config = lib.mkIf config.isStandardUser {
            isNormalUser = lib.mkDefault true;
            group = name;
          };
        }));
    };

  config.users.groups = with lib;
    mkMerge (mapAttrsToList (
        username: cfg: mkIf cfg.isStandardUser {${username} = {};}
      )
      config.users.users);
}
