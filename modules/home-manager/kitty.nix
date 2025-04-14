{...}: {
  config,
  lib,
  ...
}: {
  programs.kitty = {
    settings = {
      remember_window_size = "no";
      initial_window_width = "120c";
      initial_window_height = "40c";
      hide_window_decorations = "yes";

      background_opacity = lib.mkForce 0.97;
      transparent_background_colors = with config.lib.stylix.colors.withHashtag; "${base01}@0.99 ${base02}@0.99";

      font_family = "family=Recursive style=Linear";
      font_features = "Recursive +dlig +ss08 +ss09 +liga";

      tab_bar_edge = "top";
      tab_bar_style = "slant";

      disable_ligatures = "cursor";
      cursor = "none"; # reverse video
      cursor_shape = "beam";
      cursor_blink_interval = -1; # system default
      cursor_stop_blinking_after = 0;
      mouse_hide_wait = 0;
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      selection_foreground = "none"; # reverse video
      selection_background = "none"; # reverse video
      url_style = "curly";
      show_hyperlink_targets = "yes";

      notify_on_cmd_finish = "invisible 15 notify focus next";
    };
    keybindings = {};
    environment = {};
    shellIntegration.enableBashIntegration = true;
  };
}
