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
  services.syncthing = {
    enable = true;
    tray.enable = true;
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
    vim
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
    gnome.gnome-software

    ### GRAPHICAL ###
    vivaldi
    kitty
    clapper
  ];

  # programs.kitty.enable = true;
}
