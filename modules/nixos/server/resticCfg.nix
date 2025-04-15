{...}: {
  config,
  lib,
  ...
}: {
  options.resticCfg = let
    inherit (lib) mkOption;
    inherit (lib.types) attrsOf anything;
  in {
    repositories = mkOption {
      type = attrsOf (attrsOf anything);
      default = {};
    };
    services = mkOption {
      type = attrsOf (attrsOf anything);
      default = {};
    };
    common = mkOption {
      type = attrsOf anything;
      default = {};
    };
  };

  config.services.restic.backups =
    lib.pipe
    {
      r = lib.attrsToList config.resticCfg.repositories;
      s = lib.attrsToList config.resticCfg.services;
    }
    [
      lib.cartesianProduct
      (builtins.map (
        {
          r,
          s,
        }:
          lib.nameValuePair
          "${r.name}-${s.name}"
          (config.resticCfg.common // r.value // s.value // {repository = "${r.value.repository}/${s.name}";})
      ))
      builtins.listToAttrs
    ];
}
