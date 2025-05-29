{inputs, ...}: {
  pkgs,
  lib,
  ...
}: let
  inherit (inputs) tt-schemes;
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
  };

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.noto-fonts-emoji-blob-bin
  ];
}
