{ pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    ### ESSENTIALS ###
    home-manager
    unstable.starship
    unstable.chezmoi
    neofetch
    up
    eza
    zoxide

    ### CLI TOOLS ###
    zellij
    unstable.vim-full
    tealdeer
    btop
    kjv
    wl-clipboard
    unstable.lazygit
    unstable.ollama

    ### FONTS ###
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })

    ### GNOME ###
    gjs
    gnome.dconf-editor
    gnome-extension-manager
    gnome.file-roller
    gnome.simple-scan
    gnome.gnome-software

    ### GRAPHICAL ###
    vivaldi
    telegram-desktop # https://discourse.nixos.org/t/flatpak-telegram-desktop-desktop-entry-problems/31374
    unstable.vscode
    kitty
    virt-manager
  ];
}
