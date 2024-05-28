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
    fish
    fzf
    lazygit
    tmux
  ];

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    nix-index.enable = true;
    pandoc.enable = true;
    thefuck.enable = true;
    yazi.enable = true;
    bat.enable = true;
    btop.enable = true;
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
    atuin.enable = true;
    fish.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    tmux.enable = true;
    # configured in chezmoi
    ripgrep.enable = true;
    starship.enable = true;
    tealdeer.enable = true;
    zoxide.enable = true;
  };

  # unnixed stuff
  home.packages = with pkgs; [
      unstable.chezmoi
      neofetch
      fd
      vim-full # config in chezmoi
      dig
    ];
}
