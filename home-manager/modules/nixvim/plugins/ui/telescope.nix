{ pkgs, ... }: {
  programs.nixvim = {
    keymaps = [
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
      { key = "<Leader><Leader>'"; action = "<Cmd>Telescope marks<CR>"; options.desc = "marks"; }
      { key = "<Leader><Leader>\""; action = "<Cmd>Telescope registers<CR>"; options.desc = "registers"; }
      { key = "<Leader><Leader>/"; action = "<Cmd>Telescope current_buffer_fuzzy_find<CR>"; options.desc = "current buffer (fuzzy)"; }

      { key = "<Leader><Leader>gc"; action = "<Cmd>Telescope git_bcommits<CR>"; options.desc = "commits (current file)"; }
      { key = "<Leader><Leader>gc"; action = "<Cmd>Telescope git_bcommits_range<CR>"; options.desc = "commits (range)"; mode = ["o" "v"]; }
      { key = "<Leader><Leader>gC"; action = "<Cmd>Telescope git_commits<CR>"; options.desc = "commits (working dir)"; }
      { key = "<Leader><Leader>gb"; action = "<Cmd>Telescope git_branches<CR>"; options.desc = "branches"; }
      { key = "<Leader><Leader>gf"; action = "<Cmd>Telescope git_files<CR>"; options.desc = "files"; }
      { key = "<Leader><Leader>gs"; action = "<Cmd>Telescope git_stash<CR>"; options.desc = "stash"; }
      { key = "<Leader><Leader>gd"; action = "<Cmd>Telescope git_status<CR>"; options.desc = "diff/status"; }
    ];
    plugins.telescope = {
      enable = true;
      settings = {
        defaults = {
          sorting_strategy = "ascending";
          path_display = "filename_first";
        };
      };
      extensions = {
        undo.enable = true;
      };
    };
    plugins.which-key.registrations = {
      "<Leader><Leader>".name = "+scope";
      "<Leader><Leader>g".name = "+git";
    };
  };
}
