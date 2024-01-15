{ pkgs, unstable, ... }: {
  programs = {
    home-manager.enable = true;
    kitty.enable = true;
    vivaldi = {
      enable = true;
      commandLineArgs = [ "--force-dark-mode" ];
    };
  };
  home.packages = with pkgs; [
    ### ESSENTIALS ###
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

    ### GRAPHICAL ###
    telegram-desktop # https://discourse.nixos.org/t/flatpak-telegram-desktop-desktop-entry-problems/31374
    unstable.vscode
    virt-manager
  ];
}
