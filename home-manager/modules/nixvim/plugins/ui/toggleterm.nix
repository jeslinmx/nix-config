{ config, ... }: let
  inherit (config.nixvim.helpers) toLuaObject;
in {
  programs.nixvim = {
    keymaps = let
      tuiDefaults = { direction = "float"; close_on_exit = true; };
      tuiToggleTerm = opts: "<Cmd>lua require('toggleterm.terminal').Terminal:new(${toLuaObject (tuiDefaults // opts)}):toggle()<CR>";
    in [
      { key = "<Leader>tl"; action = tuiToggleTerm { cmd = "lazygit"; }; options.desc = "lazygit"; }
      { key = "<Leader>tb"; action = tuiToggleTerm { cmd = "btop"; }; options.desc = "btop"; }
      { key = "<Leader>tm"; action = tuiToggleTerm { cmd = "mitmproxy"; }; options.desc = "mitmproxy"; }
      { key = "<Leader>tv"; action = tuiToggleTerm { cmd = "visidata"; }; options.desc = "visidata"; }
    ];
    plugins.toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
        persist_mode = false;
        auto_scroll = false;
      };
    };
    plugins.which-key.registrations."<Leader>t".name = "+term";
  };
}
