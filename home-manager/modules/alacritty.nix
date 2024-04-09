{ config, ... }: {
  programs.alacritty.settings = {
    window = {
      dimensions = { columns = 120; lines = 40; };
      padding = { x = 8; y = 8; };
      dynamic_padding = true;
      decorations = "None";
      opacity = 0.95;
      blur = true;
    };
    font = {
      normal.family = "CaskaydiaCove NF";
      size = 8.5;
      builtin_box_drawing = false;
    };
    colors = with config.colorScheme.palette; {
      primary = {
        foreground = "#${base05}";
        background = "#${base00}";
      };
      hints = {
        start = {
          foreground = "#${base00}";
          background = "#${base0A}";
        };
        end = {
          foreground = "#${base0A}";
          background = "#${base00}";
        };
      };
      footer_bar = {
        foreground = "#${base00}";
        background = "#${base0D}";
      };
      normal = {
        black = "#${base03}";
        red = "#${base08}";
        green = "#${base0B}";
        yellow = "#${base0A}";
        blue = "#${base0D}";
        magenta = "#${base0E}";
        cyan = "#${base0C}";
        white = "#${base06}";
      };
      bright = {
        black = "#${base04}";
        red = "#${base08}";
        green = "#${base0B}";
        yellow = "#${base0A}";
        blue = "#${base0D}";
        magenta = "#${base0E}";
        cyan = "#${base0C}";
        white = "#${base07}";
      };
      transparent_background_colors = true;
    };
    selection.save_to_clipboard = true;
    cursor = {
      style = {
        shape = "Beam";
        blinking = "On";
      };
    };
  };
}
