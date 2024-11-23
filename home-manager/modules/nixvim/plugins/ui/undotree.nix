{
  programs.nixvim = {
    keymaps = [
      { key = "<Leader>u"; action = "<Cmd>UndotreeToggle<CR>"; options.desc = "undotree"; }
    ];
    plugins.undotree = {
      enable = true;
      settings = {
        WindowLayout = 3;
        ShortIndicators = 1;
        SetFocusWhenToggle = 1;
      };
    };
  };
}
