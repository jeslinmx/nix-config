{ pkgs, unstable, ... }: {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    stateVersion = "23.05";
  };
  xdg.enable = true;
  home.packages = with pkgs; [
    ### ESSENTIALS ###
    home-manager
    starship
    unstable.chezmoi
    neofetch
    ripgrep
    fzf
    gcc

    ### CLI TOOLS ###
    neovim
    up
    cloudflared
    btop
    ncdu
    kjv

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
