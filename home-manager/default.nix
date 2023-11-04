{ pkgs, unstable, ... }: {
  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    stateVersion = "23.05";
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
  xdg.enable = true;
  systemd.user.sessionVariables = {
    GDK_SCALE = "1.5";
  };
  services.syncthing.enable = true;
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
    vim-full
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
    unstable.vivaldi
    kitty
  ];

  # programs.kitty.enable = true;
}
