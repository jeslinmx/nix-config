{ flake, lib, pkgs, ... }: {
  imports = let
    nixvimModules = flake.findModulesRecursive ./.;
  in builtins.concatLists (
    lib.mapAttrsFlatten (_: v:
      lib.mapAttrsFlatten (_: v: v) v
    ) nixvimModules.plugins
  );

  home.packages = [ pkgs.zig ];
  programs.nixvim = {
    clipboard.register = "unnamedplus";
    editorconfig.enable = true;
    globalOpts = {
      listchars = "trail:◦,multispace:◦,leadmultispace:\ ,nbsp:⍽,tab:-->,precedes:«,extends:»";
      sidescroll = 5;
      timeoutlen = 300;
      foldmethod = "indent";
      foldlevelstart = 99;
      wrap = true;
      expandtabs = true;
      shiftwidth = 2;
      tabstop = 2;
    };
    globals = {
      mapleader = " ";
    };
    highlight = {};
    keymaps = let
    in [
      { key = "-"; action = "<Cmd>Oil<CR>"; mode = [ "n" ]; }
      { key = "jj"; action = "<Esc>"; mode = [ "i" ]; }
      { key = "jj"; action = "<C-\\><C-N>"; mode = [ "t" ]; }
      { key = "<Tab>"; action = "<Cmd>BufferLineCycleNext<CR>"; }
      { key = "<S-Tab>"; action = "<Cmd>BufferLineCyclePrev<CR>"; }

      { key = "<Leader>?"; action = ""; options.desc = "+docs"; }
      { key = "<Leader>?n"; action = "<Cmd>Telescope manix<CR>"; options.desc = "NixOS options"; }
    ];
    plugins = {
      mini = {
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
        };
      };
      better-escape = {}; # jj
      persistence = {}; # autosave sessions

      # LSP/completions
      cmp = {};
      conform-nvim = {}; # formatter
      dap = {}; # debug adapter protocol
      lint = {};
      lsp = {};
      schemastore = {};

      # Editor enhancements
      ccc = {}; # color picker
      comment = {};
      diffview = {};
      cursorline = {};
      emmet = {};
      flash = {}; # superpowered f/t, searches, LSP jumps
      hardtime = {};
      headlines = {};
      inc-rename = {};
      indent-blankline = {}; # indent guides
      indent-o-matic = {}; # indent autodetection
      lastplace = {}; # restore editing position in file
      leap = {};
      mark-radar = {}; # highlight marks
      multicursors = {};
      nvim-colorizer = {};
      nvim-lightbulb = {}; # code action available indicator
      nvim-ufo = {}; # better folds
      ollama = {};
      rainbow-delimiters = {};
      refactoring = {};
      spider = {}; # better word movements
      trim = {}; # trailing whitespace and lines
      yanky = {}; # yank ring and history

      # Git
      committia = {}; # 3-pane commit editor
      git-conflict = {};
      gitignore = {};
      gitlinker = {}; # git forge permalinks
      gitmessenger = {}; # line git history
      gitsigns = {}; # gutter, blame, hunk actions

      # UI
      statuscol = { enable = true; };
      todo-comments = { enable = true; };
      trouble = { enable = true; }; # problems pane
      twilight = { enable = true; }; # dims inactive code blocks using TS
      wilder = { enable = true; }; # fancier :-menu
      zen-mode = { enable = true; };

      # Integrations
      neocord = {};
      nix-develop = {}; # switch to devshell without exiting nvim
      obsidian = {};
    };
    extraPlugins = builtins.attrValues {
      inherit (pkgs.vimPlugins) auto-pairs vim-sleuth vim-numbertoggle;
    };
  };
}
