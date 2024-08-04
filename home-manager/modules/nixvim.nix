{ pkgs, ... }: {
  home.packages = [ pkgs.zig ];
  programs.nixvim = {
    autoCmd = [];
    autoGroups = {};
    editorconfig = {
      enable = true;
    };
    globalOpts = {
      cmdheight = 0;
      listchars = "trail:◦,multispace:◦,leadmultispace:\ ,nbsp:⍽,tab:-->,precedes:«,extends:»";
      sidescroll = 5;
      timeoutlen = 300;
    };
    globals = {
      mapleader = " ";
    };
    highlight = {};
    keymaps = [
      { key = "-"; action = "<Cmd>Oil<CR>"; mode = [ "n" ]; }
      { key = "jj"; action = "<Esc>"; mode = [ "i" ]; }
      { key = "jj"; action = "<C-\\><C-N>"; mode = [ "t" ]; }
      { key = "<Tab>"; action = "<Cmd>BufferLineCycleNext<CR>"; }
      { key = "<S-Tab>"; action = "<Cmd>BufferLineCyclePrev<CR>"; }

      { key = "<Leader>~"; action = "<Cmd>Alpha<CR>"; options.desc = "Open start screen (Alpha)"; }

      { key = "<Leader>b"; action = ""; options.desc = "+buffer"; }
      { key = "<Leader>bb"; action = "<Cmd>BufferLinePick<CR>"; options.desc = "Jump to buffer..."; }
      { key = "<Leader>bp"; action = "<Cmd>BufferLineTogglePin<CR>"; options.desc = "Pin"; }
      { key = "<Leader>b<"; action = "<Cmd>BufferLineMovePrev<CR>"; options.desc = "Move left"; }
      { key = "<Leader>b>"; action = "<Cmd>BufferLineMoveNext<CR>"; options.desc = "Move right"; }
      { key = "<Leader>bx"; action = "<Cmd>Bdelete<CR>"; options.desc = "Close"; }
      { key = "<Leader>bX"; action = "<Cmd>Bdelete!<CR>"; options.desc = "Close!"; }
      { key = "<Leader>b<C-x>"; action = "<Cmd>BufferLineCloseOthers<CR>"; options.desc = "Close all"; }

      { key = "<Leader>bs"; action = ""; options.desc = "+sort"; }
      { key = "<Leader>bsd"; action = "<Cmd>BufferLineSortByDirectory<CR>"; options.desc = "...by directory"; }
      { key = "<Leader>bse"; action = "<Cmd>BufferLineSortByExtension<CR>"; options.desc = "...by extension"; }
      { key = "<Leader>bsr"; action = "<Cmd>BufferLineSortByRelativeDirectory<CR>"; options.desc = "...by relative directory"; }
      { key = "<Leader>bst"; action = "<Cmd>BufferLineSortByTabs<CR>"; options.desc = "...by tab"; }
    ];
    plugins = {
      mini = {
        enable = true;
        modules = {
          basics = {
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
          animate = {
            cursor.enable = false;};
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
      nvim-autopairs = {};
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
      alpha = { # start screen
        enable = true;
        theme = "startify";
      };
      barbecue = { # context breadcrumbs
        enable = true;
        showBasename = false;
        showDirname = false;
      };
      bufferline = {
        enable = true;
        closeCommand = "BDelete! %d";
      };
      fidget = { enable = true; }; # minimalist notifications and LSP messages
      lualine = { enable = true; };
      oil = { enable = true; }; # filesystem buffers
      statuscol = { enable = true; };
      telescope = { enable = true; };
      todo-comments = { enable = true; };
      toggleterm = { enable = true; };
      trouble = { enable = true; }; # problems pane
      twilight = { enable = true; }; # dims inactive code blocks using TS
      which-key = { enable = true; };
      wilder = { enable = true; }; # fancier :-menu
      vim-bbye = { enable = true; };
      zen-mode = { enable = true; };

      # Integrations
      neocord = {};
      nix-develop = {}; # switch to devshell without exiting nvim
      obsidian = {};
    };
  };
}
