{
  programs.nixvim = {
    keymaps = [
      { key = "<Leader>bn"; action = "<Cmd>enew<CR>"; options.desc = "New"; }
      { key = "<Leader>bb"; action = "<Cmd>BufferLinePick<CR>"; options.desc = "Jump to buffer..."; }
      { key = "<Leader>bp"; action = "<Cmd>BufferLineTogglePin<CR>"; options.desc = "Pin"; }
      { key = "<Leader>b<"; action = "<Cmd>BufferLineMovePrev<CR>"; options.desc = "Move left"; }
      { key = "<Leader>b>"; action = "<Cmd>BufferLineMoveNext<CR>"; options.desc = "Move right"; }
      { key = "<Leader>bx"; action = "<Cmd>lua MiniBufremove.delete()<CR>"; options.desc = "Close"; }
      { key = "<Leader>b<C-x>"; action = "<Cmd>BufferLineCloseOthers<CR>"; options.desc = "Close all"; }

      { key = "<Leader>bsd"; action = "<Cmd>BufferLineSortByDirectory<CR>"; options.desc = "...by directory"; }
      { key = "<Leader>bse"; action = "<Cmd>BufferLineSortByExtension<CR>"; options.desc = "...by extension"; }
      { key = "<Leader>bsr"; action = "<Cmd>BufferLineSortByRelativeDirectory<CR>"; options.desc = "...by relative directory"; }
      { key = "<Leader>bst"; action = "<Cmd>BufferLineSortByTabs<CR>"; options.desc = "...by tab"; }
    ];
    plugins.bufferline = {
      enable = true;
      closeCommand = "lua MiniBufremove.delete(0, false)";
      rightMouseCommand = "";
    };
    plugins.which-key.registrations = {
      "<Leader>b".name = "+buffer";
      "<Leader>bs".name = "+sort";
    };
  };
}
