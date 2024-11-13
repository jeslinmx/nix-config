{
  flake,
  pkgs,
  lib,
  ...
}: let inherit (flake.inputs) stylix tt-schemes;
in {
  imports = [ stylix.nixosModules.stylix ];

  stylix = lib.mkDefault {
    enable = true;
    base16Scheme = "${tt-schemes}/base16/catppuccin-mocha.yaml";
    polarity = "dark";
    fonts = let
      iosevka-build-plan = {
        noCvSs = true;
        variants.design = {
          capital-i = "short-serifed";
          capital-q = "crossing";
          capital-z = "straight-serifless-with-horizontal-crossbar";
          a = "single-storey-serifless";
          g = "double-storey-open";
          i = "hooky";
          l = "serifed-flat-tailed";
          x = "chancery";
          z = "straight-serifless-with-horizontal-crossbar";
          lower-lambda = "tailed-turn";
          asterisk = "penta-low";
          brace = "straight";
          guillemet = "straight";
        };
        slopes = {
          Italic = {
            angle = 9.4;
            css = "italic";
            menu = "italic";
            shape = "italic";
          };
          Upright = {
            angle = 0;
            css = "normal";
            menu = "upright";
            shape = "upright";
          };
        };
        weights = {
          ExtraBold = {
            css = 800;
            menu = 800;
            shape = 800;
          };
          ExtraLight = {
            css = 200;
            menu = 200;
            shape = 200;
          };
          Regular = {
            css = 400;
            menu = 400;
            shape = 400;
          };
        };
      };
    in {
      sansSerif = rec {
        name = "Iosevka Custom Proportional";
        package = pkgs.iosevka.override { set = "-custom-prop"; privateBuildPlan = iosevka-build-plan // {
          family = name;
          spacing = "quasi-proportional";
          serifs = "sans";
        }; };
      };
      serif = rec {
        name = "Iosevka Custom Slab";
        package = pkgs.iosevka.override { set = "-custom-slab"; privateBuildPlan = iosevka-build-plan // {
          family = name;
          spacing = "quasi-proportional";
          serifs = "slab";
        }; };
      };
      monospace = rec {
        name = "Iosevka Custom Term";
        package = pkgs.iosevka.override { set = "-custom-term"; privateBuildPlan = iosevka-build-plan // {
          family = name;
          spacing = "term";
          serifs = "sans";
          exportGlyphNames = true;
        }; };
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
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    pkgs.noto-fonts-emoji-blob-bin
  ];

}
