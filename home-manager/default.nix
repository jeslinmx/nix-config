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
    unstable.starship
    unstable.chezmoi
    neofetch
    gcc

    ### CLI TOOLS ###
    tmux
    unstable.vim-full
    up
    btop
    ncdu
    kjv
    wl-clipboard
    unstable.lazygit
    unstable.ollama

    ### GNOME ###
    gjs
    gnome.dconf-editor
    gnome-extension-manager
    gnome.file-roller
    gnome.simple-scan
    gnome.gnome-software

    ### GRAPHICAL ###
    unstable.vivaldi
    telegram-desktop # https://discourse.nixos.org/t/flatpak-telegram-desktop-desktop-entry-problems/31374
    unstable.vscode
    kitty
    virt-manager
  ];

  # programs.kitty.enable = true;
}
