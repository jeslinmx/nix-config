{ config, pkgs, ... }: let
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
      { key = "<Leader><Leader>t"; action = "<Cmd>Telescope termfinder find<CR>"; options.desc = "terminals"; }
    ];
    plugins.toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
        auto_scroll = false;
        hide_numbers = false;
      };
    };
    plugins.which-key.registrations."<Leader>t".name = "+term";
    plugins.telescope.enabledExtensions = [ "termfinder" ];
    extraPlugins = builtins.attrValues {
      telescope-termfinder = pkgs.vimUtils.buildVimPlugin {
        name = "telescope-termfinder.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "tknightz";
          repo = "telescope-termfinder.nvim";
          rev = "d639bfae1ff5e644700f20d208b2224648b573cf";
          hash = "sha256-9OvEQvMgDM2KqvGq4j6cwHXE060XDiyZEj5b5ouBohI=";
        };
      };
    };
  };
}
