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
    atuin
    btop
    firefox
    fish
    kitty
    tmux
  ];

  services = {
    syncthing.enable = true;
  };

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    thefuck.enable = true;
    yazi.enable = true;
    bat = {
      enable = true;
      config.theme = "base16";
    };
    eza = {
      enable = true;
      git = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    ssh = {
      enable = true;
      hashKnownHosts = true;
      controlMaster = "auto";
      controlPersist = "3s";
      includes = [ "~/.ssh/config.d/*.conf" ];
    };
    # configured in dedicated modules
    firefox.enable = true;
    kitty.enable = true;
    tmux.enable = true;
    fish.enable = true;
    atuin.enable = true;
    btop.enable = true;
    # configured in chezmoi
    zoxide.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    lazygit.enable = true;
    starship.enable = true;
  };

  # unnixed stuff
  home.packages = with pkgs; [
      ### ESSENTIALS ###
      unstable.chezmoi
      neofetch
      fd

      ### CLI TOOLS ###
      vim-full # config in chezmoi
      wl-clipboard
      ( unstable.ollama.override { acceleration = "cuda"; } )
      dig

      ### GRAPHICAL ###
      virt-manager
    ];
}
