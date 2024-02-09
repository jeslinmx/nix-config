{
  pkgs,
  nixpkgs-unstable,
  ...
}: {
  services = {
    syncthing.enable = true;
  };

  programs = {
    home-manager.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
      };
    };
    tealdeer = {
      enable = true;
      settings = {updates.auto_update = true;};
    };
    eza.enable = true; # config in chezmoi
    lazygit.enable = true; # config in chezmoi
    starship.enable = true; # config in chezmoi
    zoxide.enable = true; # config in chezmoi

    vivaldi = {
      enable = true;
      commandLineArgs = ["--force-dark-mode" "--enable-features=UseOzonePlatform" "--ozone-pltform=wayland"];
    };
    vscode.enable = true; # natively handles config sync
    firefox.enable = true; # config in dedicated module
    kitty.enable = true; # config in dedicated module
  };

  # unnixed stuff
  home.packages = let
    nixpkgs-config = {inherit (pkgs) system config;};
    unstable = import nixpkgs-unstable nixpkgs-config;
  in
    with pkgs; [
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
      floorp
    ];
}
