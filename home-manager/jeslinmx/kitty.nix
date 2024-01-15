{ lib, config, hostConfig, pkgs, ... }: lib.mkIf config.programs.kitty.enable {
  programs.kitty = {
    theme = "Catppuccin-Mocha";
    font = {
      name = "CaskaydiaCove NF";
      package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
      size = 8.5;
    };
    settings = {
      remember_window_size = "no";
      initial_window_width = "80c";
      initial_window_height = "25c";
      window_padding_width = 8;
      hide_window_decorations = "yes";

      tab_bar_edge = "top";
      tab_bar_style = "slant";
      tab_powerline_style = "slanted";

      font_features = "+ss00 +ss19";
      disable_ligatures = "cursor";
      cursor = "none";
      cursor_blink_interval = -1;
      cursor_stop_blinking_after = 0;
      mouse_hide_wait = 0;

      url_color = "#89b4fa";
      url_style = "curly";
      show_hyperlink_targets = "yes";
    };
    keybindings = {};
    environment = {};
    shellIntegration.enableBashIntegration = true;
  };
}
