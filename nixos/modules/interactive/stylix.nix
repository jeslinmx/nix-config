{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake.inputs) stylix tt-schemes;
in {
  imports = [stylix.nixosModules.stylix];

  stylix = lib.mkDefault {
    enable = true;
    base16Scheme = "${tt-schemes}/base16/catppuccin-mocha.yaml";
    polarity = "dark";
    fonts = {
      sansSerif = {
        name = "Recursive Sans Linear Static";
        package = pkgs.recursive;
      };
      serif = {
        name = "Recursive Sans Linear Static";
        package = pkgs.recursive;
      };
      monospace = {
        name = "Recursive Mono Linear Static";
        package = pkgs.recursive;
      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
    };
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    pkgs.noto-fonts-emoji-blob-bin
  ];
}
