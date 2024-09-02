{
  flake,
  pkgs,
  ...
}: let
    nixpkgs-config = {inherit (pkgs) system config;};
    unstable = import flake.inputs.nixpkgs-unstable nixpkgs-config;
  in
{
  imports = builtins.attrValues { inherit (flake.homeModules)
    atuin
    fish
    fzf
    git
    lazygit
    nixvim
    starship
    tmux
  ;};

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    nix-index.enable = true;
    pandoc.enable = true;
    thefuck.enable = true;
    yazi.enable = true;
    bat.enable = true;
    btop.enable = true;
    zoxide.enable = true;
    eza = {
      enable = true;
      git = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow" # symlinks
        "--glob=!.git/*"
      ];
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
    git.enable = true;
    lazygit.enable = true;
    nixvim.enable = true;
    starship.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };

  # unnixed stuff
  home.packages = builtins.attrValues { inherit (pkgs)
      fd
      dig
      lazydocker
      unzip
      visidata
      httpie
      mitmproxy
    ;};
  home.file = {
    ".config/lazydocker/config.yml".source = pkgs.writers.writeYAML "config.yml" {
      commandTemplates = {
        dockerCompose = "podman compose";
      };
    };
  };
}
