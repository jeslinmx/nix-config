{homeModules, ...}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit
      (homeModules)
      atuin
      comma
      fish
      fzf
      git
      lazygit
      neovim
      starship
      # termshark
      tmux
      yazi
      ;
  };

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    pandoc.enable = true;
    thefuck.enable = true;
    bat.enable = true;
    btop.enable = true;
    zoxide.enable = true;
    eza = {
      enable = true;
      git = true;
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
      addKeysToAgent = "yes";
      hashKnownHosts = true;
      controlMaster = "auto";
      controlPersist = "3s";
      extraConfig = ''
        IgnoreUnknown UseKeychain
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519
        IdentityFile ~/.ssh/id_rsa
      '';
      includes = ["~/.ssh/config.d/*.conf"];
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
      extensions = builtins.attrValues {
        inherit (pkgs) gh-notify gh-dash;
      };
    };
    # configured in dedicated modules
    atuin.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    lazygit.enable = true;
    neovim.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  # unnixed stuff
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      fd
      dig
      lazydocker
      ouch
      visidata
      httpie
      mitmproxy
      dust
      hyperfine
      tokei
      wiki-tui
      mask
      ;
  };
  home.file = {
    ".config/lazydocker/config.yml".source = pkgs.writers.writeYAML "config.yml" {
      commandTemplates = {
        dockerCompose = "podman compose";
      };
    };
  };
}
