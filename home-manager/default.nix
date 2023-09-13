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
    neovim
    starship
    unstable.chezmoi
    neofetch
    ripgrep
    fzf
    gcc
    cloudflared
    btop

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
    steam
    prismlauncher-qt5
    obsidian
    keepassxc
    telegram-desktop
    xiphos
  ];
  # programs.starship.enable = true;
  # programs.kitty.enable = true;
}
