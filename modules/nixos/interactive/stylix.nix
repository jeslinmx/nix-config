{inputs, ...}: {
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (inputs) stylix tt-schemes;
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
      # hotfix for https://github.com/nix-community/stylix/issues/1396
      size = lib.mkDefault 0;
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.noto-fonts-emoji-blob-bin
  ];
}
