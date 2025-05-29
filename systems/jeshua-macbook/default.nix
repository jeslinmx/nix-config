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
    "whisky"
    "discord"
    "prismlauncher"
    "transmission-remote-gui"
    "vlc"

    # Services
    "zerotier-one"
    "syncthing"
    "lm-studio"

    # Desktop
    "scroll-reverser"
    "middleclick"
    "jordanbaird-ice"
    "domzilla-caffeine"
    "maccy"
  ];

  programs.fish.enable = true;
  hmUsers.jeslinmx = {
    uid = 501;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];
    hmModules =
      (with homeModules; [
        cli-programs
        {
          home.stateVersion = "24.11";
          targets.darwin.search = "DuckDuckGo";
          # TODO: remove when https://github.com/danth/stylix/issues/1316 comes to release-24.11
          stylix.targets.gnome.enable = false;
        }
      ])
      ++ (with inputs.private-config.homeModules; [
        ssh-personal-hosts
        ssh-speqtral-hosts
      ]);
  };
}
