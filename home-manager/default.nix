{ pkgs, unstable, ... }: {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    stateVersion = "23.05";
  };
  xdg.enable = true;
  systemd.user.sessionVariables = {
    GDK_SCALE = "1.5";
  };
  home.packages = with pkgs; [
    ### ESSENTIALS ###
    home-manager
    starship
    unstable.chezmoi
    neofetch
    ripgrep
    fzf
    gcc
    desktop-file-utils

    ### CLI TOOLS ###
    neovim
    up
    btop
    ncdu
    kjv
    wl-clipboard
    lazygit

    ### GNOME ###
    gjs
    gnome.dconf-editor
    gnome-extension-manager
    gnome.file-roller
    gnome.simple-scan

    ### GRAPHICAL ###
    vivaldi
    kitty
    discord
    clapper
    vscode
    prismlauncher
    obsidian
    keepassxc
    telegram-desktop
    xiphos
    onlyoffice-bin
  ];

  # programs.starship.enable = true;
  # programs.kitty.enable = true;
}
