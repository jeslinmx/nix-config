{
  inputs,
  darwinModules,
  nixosModules,
  homeModules,
  ...
}: {pkgs, ...}: {
  imports = with darwinModules; [
    inputs.stylix.darwinModules.stylix
    sudo
    sshd
    stylix
    homebrew
    home-manager-users
    macos-desktop
    rosetta-builder
    nixosModules.base-nix-config
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "jeshua-macbook";
  system.stateVersion = 5;

  homebrew.casks = [
    # Applications
    "zen-browser"
    "telegram"
    "obsidian"
    "ticktick"
    "iterm2"
    "keepassxc"
    "godot"
    "figma"
    "obs"
    "bambu-studio"
    "microsoft-word"
    "microsoft-powerpoint"
    "microsoft-excel"
    "steam"
    "discord"
    "prismlauncher"
    "transmission-remote-gui"
    "vlc"
    "eloston-chromium"
    "imageoptim"

    # Services
    "zerotier-one"
    "syncthing"

    # Desktop
    "scroll-reverser"
    "middleclick"
    "jordanbaird-ice"
    "raycast"
  ];

  programs.fish.enable = true;
  system.primaryUser = "jeslinmx";
  hmUsers.jeslinmx = {
    uid = 501;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
    hmModules =
      (with homeModules; [
        cli-programs
        ollama
        {
          home.stateVersion = "24.11";
          targets.darwin.search = "DuckDuckGo";
          # TODO: remove when https://github.com/danth/stylix/issues/1316 comes to release-25.11
          stylix.targets.gnome.enable = false;
        }
      ])
      ++ (with inputs.private-config.homeModules; [
        ssh-personal-hosts
        ssh-speqtral-hosts
      ]);
  };
}
