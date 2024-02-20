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
    btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
      };
    };
    tealdeer = {
      enable = true;
      # temporarily disabled until updateOnActivation is supported in a stable release
      # updateOnActivation = false; # otherwise HM service errors due to lack of connectivity
      # settings = {updates.auto_update = true;};
    };
    home-manager.enable = true;
    eza.enable = true; # config in chezmoi
    zoxide.enable = true; # config in chezmoi
    fzf.enable = true; # config in chezmoi
    ripgrep.enable = true; # config in chezmoi
    lazygit.enable = true; # config in chezmoi
    starship.enable = true; # config in chezmoi

    vivaldi = {
      enable = true;
      package = unstable.vivaldi;
      commandLineArgs = ["--force-dark-mode" "--enable-features=UseOzonePlatform" "--ozone-pltform=wayland"];
    };
    firefox.enable = true; # config in dedicated module
    kitty.enable = true; # config in dedicated module
  };

  # unnixed stuff
  home.packages = with pkgs; [
      ### ESSENTIALS ###
      unstable.chezmoi
      neofetch
      up

      ### CLI TOOLS ###
      vim-full # config in chezmoi
      rclone
      wl-clipboard
      unstable.ollama

      ### GRAPHICAL ###
      virt-manager
    ];
}
