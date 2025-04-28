{...}: {
  config,
  lib,
  ...
}: {
  options.backups.restic = let
    inherit (lib) mkOption;
    inherit (lib.types) attrsOf anything boolByOr;
  in {
    repositories = mkOption {
      description = "Configs of repositories to backup each service to";
      type = attrsOf (attrsOf anything);
      default = {};
    };
    services = mkOption {
      description = "Configs of services to backup to each repository";
      type = attrsOf (attrsOf anything);
      default = {};
    };
    common = mkOption {
      description = "Config to apply to all backup jobs";
      type = attrsOf anything;
      default = {};
    };
    obfuscateServiceNames = mkOption {
      description = "Hash all service names in the repository paths";
      type = boolByOr;
      default = false;
    };
  };

  config.services.restic.backups = let
    cfg = config.backups.restic;
  in
    lib.pipe
    {
      r = lib.attrsToList cfg.repositories;
      s = lib.attrsToList cfg.services;
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
          (cfg.common
            // r.value
            // s.value
            // {
              repository = "${r.value.repository}/${
                if cfg.obfuscateServiceNames
                then builtins.hashString "sha256" s.name
                else s.name
              }";
            })
      ))
      builtins.listToAttrs
    ];
}
