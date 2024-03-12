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
    carapace.enable = true;
    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      secureSocket = true;
      sensibleOnTop = true;
      extraConfig = ''
        # for kitty images
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
      '';
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        update_check = false;
        style = "compact";
        inline_height = 9 + 4; # header, current, input, preview
        show_preview = true;
        enter_accept = false;
        exit_mode = "return-query";
      };
    };
    thefuck.enable = true;
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
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    ssh = {
      enable = true;
      hashKnownHosts = true;
      controlMaster = "auto";
      controlPersist = "3s";
      includes = [ "~/.ssh/config.d/*.conf" ];
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
