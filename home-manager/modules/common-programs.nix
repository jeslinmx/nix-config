{
  homeModules,
  pkgs,
  nixpkgs-unstable,
  ...
}: let
    nixpkgs-config = {inherit (pkgs) system config;};
    unstable = import nixpkgs-unstable nixpkgs-config;
  in
{
  imports = with homeModules; [
    firefox
    kitty
  ];

  services = {
    syncthing.enable = true;
  };

  programs = {
    home-manager.enable = true;
    firefox.enable = true; # config in dedicated module
    kitty.enable = true; # config in dedicated module

    btop = { # btop overwrites its config, so it's annoying in chezmoi
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
      };
    };
    eza.enable = true; # config in chezmoi
    zoxide.enable = true; # config in chezmoi
    fzf.enable = true; # config in chezmoi
    ripgrep.enable = true; # config in chezmoi
    tealdeer.enable = true; # config in chezmoi
    lazygit.enable = true; # config in chezmoi
    starship.enable = true; # config in chezmoi
  };

  # unnixed stuff
  home.packages = with pkgs; [
      ### ESSENTIALS ###
      unstable.chezmoi
      neofetch
      up

      ### CLI TOOLS ###
      vim-full # config in chezmoi
      wl-clipboard
      unstable.ollama
      dig

      ### GRAPHICAL ###
      virt-manager
    ];
}
