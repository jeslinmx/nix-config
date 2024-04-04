{
  pkgs,
  config,
  ...
}:
{
  programs.kitty = {
    theme = "Catppuccin-Mocha";
    font = {
      name = "CaskaydiaCove NF";
      package = pkgs.nerdfonts.override {fonts = ["CascadiaCode"];};
      size = 8.5;
    };
    settings = with config.colorScheme.palette; {
      remember_window_size = "no";
      initial_window_width = "120c";
      initial_window_height = "40c";
      window_padding_width = 8;
      hide_window_decorations = "yes";

      tab_bar_edge = "top";
      tab_bar_style = "slant";
      tab_bar_background = "#${base01}";
      active_tab_foreground = "#${base0D}";
      active_tab_background = "#${base00}";
      inactive_tab_foreground = "#${base03}";
      inactive_tab_background = "#${base01}";

      font_features = "+ss00 +ss19";
      disable_ligatures = "cursor";
      cursor = "none"; # reverse video
      cursor_shape = "beam";
      cursor_blink_interval = -1; # system default
      cursor_stop_blinking_after = 0;
      mouse_hide_wait = 0;

      foreground = "#${base05}";
      background = "#${base00}";
      selection_foreground = "none"; # reverse video
      selection_background = "none"; # reverse video
      # black
      color0 = "#${base03}";
      color8 = "#${base04}";
      # red
      color1 = "#${base08}";
      color9 = "#${base08}";
      # green
      color2  = "#${base0B}";
      color10 = "#${base0B}";
      # yellow
      color3  = "#${base0A}";
      color11 = "#${base0A}";
      # blue
      color4  = "#${base0D}";
      color12 = "#${base0D}";
      # magenta
      color5  = "#${base0E}";
      color13 = "#${base0E}";
      # cyan
      color6  = "#${base0C}";
      color14 = "#${base0C}";
      # white
      color7  = "#${base06}";
      color15 = "#${base07}";

      url_color = "#${base0D}";
      url_style = "curly";
      show_hyperlink_targets = "yes";
    };
    keybindings = {};
    environment = {};
    shellIntegration.enableBashIntegration = true;
  };
}
