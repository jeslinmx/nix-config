{ pkgs, ... }: {
  programs.neovim = {
    defaultEditor = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs) zig lua-language-server stylua gopls nixd;
      inherit (pkgs.python312Packages) python-lsp-server;
    };
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  xdg.configFile.nvim.source = ./.;
}
