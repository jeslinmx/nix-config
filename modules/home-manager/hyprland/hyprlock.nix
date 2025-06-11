{...}: {
  config,
  lib,
  pkgs, # don't believe LSP, this is needed
  ...
} @ args: let
  common = (import ./common.nix) args;
  inherit (common) rgb;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        immediate_render = true;
      };
      background = {
        color = rgb "base01";
        path = lib.mkIf (!builtins.isNull config.stylix.image) "${config.stylix.image}";
        reload_cmd = ''swww query | sed -n "1s/.*image: \(.*\)/\1/;1p"'';
        reload_time = 1;
      };
      input-field = {
        position = "0, 0";
        halign = "center";
        valign = "center";
        size = "480, 60";
        rounding = 24;
        dots_rounding = -2;
        dots_size = 0.5;
        dots_spacing = 0.2;
        inner_color = rgb "base00";
        font_color = rgb "base0D";
        outline_thickness = 2;
        outer_color = rgb "base00";
        fade_on_empty = false;
        placeholder_text = "enter password";
        check_color = rgb "base0A";
        fail_color = rgb "base08";
        fail_text = "$FAIL ($ATTEMPTS attempts)";
      };
      label = {
        text = "Is that you, $DESC?";
        text_align = "center";
        color = rgb "base05";
        position = "0, 60";
        halign = "center";
        valign = "center";
      };
    };
  };
  stylix.targets.hyprlock.enable = false;
}
