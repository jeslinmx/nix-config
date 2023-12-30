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
  xdg.dataFile."applications/vivaldi-stable.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Vivaldi
    GenericName=Web Browser
    Comment=Access the Internet
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode %U
    StartupNotify=true
    Terminal=false
    Icon=vivaldi
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/ftp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/mailto;
    Actions=new-window;new-private-window;

    [Desktop Action new-window]
    Name=New Window
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode --new-window

    [Desktop Action new-private-window]
    Name=New Private Window
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode --incognito
  '';
}
