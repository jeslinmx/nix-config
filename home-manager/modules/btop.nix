{ pkgs, ... }: {
  programs.btop = {
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };
  xdg.configFile."btop/themes".source = pkgs.fetchzip {
    url = "https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz";
    hash = "sha256-9eaLAaa2CIaP1txcu7sFdAODSLjbCziYlgfy9Z80sz0=";
  };
}
