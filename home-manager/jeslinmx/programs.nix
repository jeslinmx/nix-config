{ pkgs, unstable, ... }: {
  programs = {
    btop = { enable = true; settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    }; };
    eza.enable = true; # config in chezmoi
    home-manager.enable = true;
    lazygit.enable = true; # config in chezmoi
    starship.enable = true; # config in chezmoi
    tealdeer = { enable = true; settings = { updates.auto_update = true; }; };
    zoxide.enable = true; # config in chezmoi

    kitty.enable = true; # config in dedicated module
    vivaldi = { enable = true; commandLineArgs = [ "--force-dark-mode" "--enable-features=UseOzonePlatform" "--ozone-pltform=wayland" ]; };
    vscode.enable = true;
  };

  # unnixed stuff
  home.packages = with pkgs; [
    ### ESSENTIALS ###
    unstable.chezmoi
    neofetch
    up

    ### CLI TOOLS ###
    vim-full # config in chezmoi
    kjv
    wl-clipboard
    unstable.ollama

    ### GRAPHICAL ###
    telegram-desktop # https://discourse.nixos.org/t/flatpak-telegram-desktop-desktop-entry-problems/31374
    virt-manager
  ];
}
