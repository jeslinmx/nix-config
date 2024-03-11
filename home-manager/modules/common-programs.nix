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
    btop
    firefox
    fish
    kitty
  ];

  services = {
    syncthing.enable = true;
  };

  programs = {
    home-manager.enable = true;
    firefox.enable = true; # config in dedicated module
    kitty.enable = true; # config in dedicated module

    fish.enable = true; # config in dedicated module
    btop.enable = true; # config in dedicated module
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
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
