{
  flake,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (flake.inputs) stylix tt-schemes;
in {
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

    # TODO: remove when https://github.com/danth/stylix/issues/442 goes through
    image = config.lib.stylix.pixel "base00";
  };

  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    pkgs.noto-fonts-emoji-blob-bin
  ];
}
