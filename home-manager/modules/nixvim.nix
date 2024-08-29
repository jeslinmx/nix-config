{ config, pkgs, ... }: {
  home.packages = [ pkgs.zig ];
  programs.nixvim = let
    inherit (config.nixvim) helpers;
  in {
    autoCmd = [];
    autoGroups = {};
    clipboard.register = "unnamedplus";
    editorconfig.enable = true;
    globalOpts = {
      listchars = "trail:◦,multispace:◦,leadmultispace:\ ,nbsp:⍽,tab:-->,precedes:«,extends:»";
      sidescroll = 5;
      timeoutlen = 300;
      foldmethod = "indent";
    };
    globals = {
      mapleader = " ";
    };
    highlight = {};
    keymaps = let
      group = key: desc: { inherit key; action = "<Cmd>WhichKey ${key}<CR>"; options.desc = desc; };
    in [
      { key = "-"; action = "<Cmd>Oil<CR>"; mode = [ "n" ]; }
      { key = "jj"; action = "<Esc>"; mode = [ "i" ]; }
      { key = "jj"; action = "<C-\\><C-N>"; mode = [ "t" ]; }
      { key = "<Tab>"; action = "<Cmd>BufferLineCycleNext<CR>"; }
      { key = "<S-Tab>"; action = "<Cmd>BufferLineCyclePrev<CR>"; }

      { key = "<Leader>~"; action = "<Cmd>Alpha<CR>"; options.desc = "Open start screen (Alpha)"; }

      ( group "<Leader><Leader>" "+scope" )
      { key = "<Leader><Leader>a"; action = "<Cmd>Telescope autocommands<CR>"; options.desc = "autocommands"; }
      { key = "<Leader><Leader>b"; action = "<Cmd>Telescope buffers<CR>"; options.desc = "buffers"; }
      { key = "<Leader><Leader>c"; action = "<Cmd>Telescope commands<CR>"; options.desc = "commands"; }
      { key = "<Leader><Leader>f"; action = "<Cmd>Telescope find_files<CR>"; options.desc = "files"; }
      { key = "<Leader><Leader>r"; action = "<Cmd>Telescope live_grep<CR>"; options.desc = "ripgrep"; }
      { key = "<Leader><Leader>:"; action = "<Cmd>Telescope command_history<CR>"; options.desc = ":-history"; }
      { key = "<Leader><Leader>h"; action = "<Cmd>Telescope help_tags<CR>"; options.desc = "help"; }
      { key = "<Leader><Leader>j"; action = "<Cmd>Telescope jumplist<CR>"; options.desc = "jumps"; }
      { key = "<Leader><Leader>m"; action = "<Cmd>Telescope man_pages<CR>"; options.desc = "man"; }
      { key = "<Leader><Leader>x"; action = "<Cmd>Telescope oldfiles<CR>"; options.desc = "recently closed"; }
      { key = "<Leader><Leader>o"; action = "<Cmd>Telescope vim_options<CR>"; options.desc = "options"; }
      { key = "<Leader><Leader>t"; action = "<Cmd>Telescope filetypes<CR>"; options.desc = "filetypes"; }
      { key = "<Leader><Leader>'"; action = "<Cmd>Telescope marks<CR>"; options.desc = "marks"; }
      { key = "<Leader><Leader>\""; action = "<Cmd>Telescope registers<CR>"; options.desc = "registers"; }
      { key = "<Leader><Leader>/"; action = "<Cmd>Telescope current_buffer_fuzzy_find<CR>"; options.desc = "current buffer (fuzzy)"; }

      ( group "<Leader><Leader>g" "+git" )
      { key = "<Leader><Leader>gc"; action = "<Cmd>Telescope git_bcommits<CR>"; options.desc = "commits (current file)"; }
      { key = "<Leader><Leader>gc"; action = "<Cmd>Telescope git_bcommits_range<CR>"; options.desc = "commits (range)"; mode = ["o" "v"]; }
      { key = "<Leader><Leader>gC"; action = "<Cmd>Telescope git_commits<CR>"; options.desc = "commits (working dir)"; }
      { key = "<Leader><Leader>gb"; action = "<Cmd>Telescope git_branches<CR>"; options.desc = "branches"; }
      { key = "<Leader><Leader>gf"; action = "<Cmd>Telescope git_files<CR>"; options.desc = "files"; }
      { key = "<Leader><Leader>gs"; action = "<Cmd>Telescope git_stash<CR>"; options.desc = "stash"; }
      { key = "<Leader><Leader>gd"; action = "<Cmd>Telescope git_status<CR>"; options.desc = "diff/status"; }

      ( group "<Leader>b" "+buffer" )
      { key = "<Leader>bn"; action = "<Cmd>enew<CR>"; options.desc = "New"; }
      { key = "<Leader>bb"; action = "<Cmd>BufferLinePick<CR>"; options.desc = "Jump to buffer..."; }
      { key = "<Leader>bp"; action = "<Cmd>BufferLineTogglePin<CR>"; options.desc = "Pin"; }
      { key = "<Leader>b<"; action = "<Cmd>BufferLineMovePrev<CR>"; options.desc = "Move left"; }
      { key = "<Leader>b>"; action = "<Cmd>BufferLineMoveNext<CR>"; options.desc = "Move right"; }
      { key = "<Leader>bx"; action = "<Cmd>lua MiniBufremove.delete()<CR>"; options.desc = "Close"; }
      { key = "<Leader>b<C-x>"; action = "<Cmd>BufferLineCloseOthers<CR>"; options.desc = "Close all"; }

      ( group "<Leader>bs" "+sort" )
      { key = "<Leader>bsd"; action = "<Cmd>BufferLineSortByDirectory<CR>"; options.desc = "...by directory"; }
      { key = "<Leader>bse"; action = "<Cmd>BufferLineSortByExtension<CR>"; options.desc = "...by extension"; }
      { key = "<Leader>bsr"; action = "<Cmd>BufferLineSortByRelativeDirectory<CR>"; options.desc = "...by relative directory"; }
      { key = "<Leader>bst"; action = "<Cmd>BufferLineSortByTabs<CR>"; options.desc = "...by tab"; }
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
          animate = { # neoscroll
            cursor.enable = false;
            scroll.subscroll = helpers.mkRaw ''
              require('mini.animate').gen_subscroll.equal({ predicate = function(total_scroll) return total_scroll > 3 end })
            '';
          };
          ai = {}; # more text objects
          operators = {}; # ReplaceWithRegister (and others)
          bufremove = {}; # vim-bbye
          pairs = {}; # auto-pairs
          surround = {
            mappings = {
              add = "ys";
              delete = "ds";
              replace = "cs";
              find = ""; find_left = ""; highlight = ""; update_n_lines = "";
            };
          };
          indentscope = {
            draw = {
              delay = 0;
              animation = helpers.mkRaw ''
                require('mini.indentscope').gen_animation.none()
              '';
            };
          };
          diff = {}; # gitsigns
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
        closeCommand = "lua MiniBufremove.delete(0, false)";
        rightMouseCommand = "";
      };
      fidget = { enable = true; }; # minimalist notifications and LSP messages
      lualine = {
        enable = true;
        extensions = [];
        sections = {
          lualine_a = [
            {
              name = "mode";
              separator.left = "";
              fmt = ''
                function(str) return ({
                  NORMAL = "",
                  INSERT = "󰏫",
                  COMMAND = ":",
                  VISUAL = "󰛐",
                  ['V-LINE'] = "󱀧",
                  ['V-BLOCK'] = "󱈝",
                  SELECT = "",
                  ['S-LINE'] = "",
                  ['S-BLOCK'] = "󰒅",
                  REPLACE = "󰯍",
                  ['V-REPLACE'] = "󰾵",
                  TERMINAL = "",
                  ['O-PENDING'] = "…",
                  EX = "E",
                  MORE = "",
                  CONFIRM = "",
                  SHELL = ""
                })[str] end
              '';
            }
          ];
          lualine_b = [
            "branch"
            "diff"
          ];
          lualine_c = [
            { name = "filetype"; padding = { left = 1; right = 0; }; extraConfig = { icon_only = true; draw_empty = true; }; }
            { name = "filename";
              padding = { left = 0; right = 1; };
              extraConfig = {
                newfile_status = true;
                path = 1;
                symbols = {
                  modified = "󰏫";
                  readonly = "󰏯";
                  newfile = "";
                };
              }; }
            "encoding"
            "fileformat"
          ];
          lualine_x = [
            "searchcount"
            "selectioncount"
          ];
          lualine_y = [
            "progress"
            "location"
          ];
          lualine_z = [
            { name = "diagnostics"; separator.right = ""; extraConfig.draw_empty = true; }
          ];
        };
        sectionSeparators = {
          left = "";
          right = "";
        };
        componentSeparators = {
          left = "";
          right = "";
        };
      };
      oil = { enable = true; };
      statuscol = { enable = true; };
      telescope = {
        enable = true;
        settings = {
          defaults = {
            sorting_strategy = "ascending";
            path_display = "filename_first";
          };
        };
      };
      todo-comments = { enable = true; };
      toggleterm = { enable = true; };
      trouble = { enable = true; }; # problems pane
      twilight = { enable = true; }; # dims inactive code blocks using TS
      which-key = {
        enable = true;
        operators = {
          gh = "Hunks to apply";
          gH = "Hunks to reset";
        };
        triggersNoWait = [ "<leader>" ];
      };
      wilder = { enable = true; }; # fancier :-menu
      zen-mode = { enable = true; };

      # Integrations
      neocord = {};
      nix-develop = {}; # switch to devshell without exiting nvim
      obsidian = {};
    };
    extraPlugins = builtins.attrValues {
      inherit (pkgs.vimPlugins) vim-sleuth vim-numbertoggle;
    };
  };
}
