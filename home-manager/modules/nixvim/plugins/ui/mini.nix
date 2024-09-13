{ config, ... }: let
  inherit (config.nixvim.helpers) mkRaw;
in {
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      basics = { # vim-sensible
        options = {
          extra_ui = true;
          win_borders = "single";
        };
        mappings = {
          windows = true;
          move_with_alt = true;
        };
        autocommands = {
          relnum_in_visual_mode = true;
        };
      };
      animate = { # neoscroll
        cursor.enable = false;
        scroll.subscroll = mkRaw ''
          require('mini.animate').gen_subscroll.equal({ predicate = function(total_scroll) return total_scroll > 3 end })
        '';
      };
      bufremove = {}; # vim-bbye
      indentscope = {
        draw = {
          delay = 0;
          animation = mkRaw ''
            require('mini.indentscope').gen_animation.none()
          '';
        };
      };
      diff = {}; # gitsigns
    };
  };
}
