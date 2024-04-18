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
    fish
    tmux
  ];

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    nix-index.enable = true;
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
    atuin.enable = true;
    btop.enable = true;
    fish.enable = true;
    tmux.enable = true;
    # configured in chezmoi
    fzf.enable = true;
    lazygit.enable = true;
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
