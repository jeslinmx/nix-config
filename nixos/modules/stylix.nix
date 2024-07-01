{
  pkgs,
  lib,
  stylix,
  tt-schemes,
  ...
}: {
  imports = [ stylix.nixosModules.stylix ];

  stylix = lib.mkDefault {
    enable = true;
    base16Scheme = "${tt-schemes}/base16/catppuccin-mocha.yaml";
    polarity = "dark";
    fonts = {
      sansSerif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };
      serif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };
      monospace = {
        name = "Cascadia Code";
        package = pkgs.cascadia-code;
      };
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };
}
