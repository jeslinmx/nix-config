{ lib, config, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  options.colors = with lib; {
    scheme = mkOption {
      type = types.enum (builtins.attrNames nix-colors.colorSchemes);
      default = "catppuccin-mocha";
    };
  };

  config =
    let cfg = config.colors;
    in lib.mkIf (! builtins.isNull cfg.scheme) {
      colorScheme = lib.mkForce nix-colors.colorSchemes.${cfg.scheme};
      home.sessionVariables.BASE16_THEME = cfg.scheme;
    };
}
