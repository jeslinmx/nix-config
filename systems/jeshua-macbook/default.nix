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
    linux-builder
    nixosModules.base-nix-config
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "jeshua-macbook";
  system.stateVersion = 5;

  homebrew.casks = [
    "iterm2"
    "whisky"
    "keepassxc"
    "telegram"
    "microsoft-word"
    "microsoft-powerpoint"
    "microsoft-excel"
    "obsidian"
    "godot"
    "discord"
    "prismlauncher"
    "figma"
    "orion"
    "firefox"
    "obs"
    "zerotier-one"
    "syncthing"
    "scroll-reverser"
    "lm-studio"
    "ticktick"
    "transmission-remote-gui"
    "vlc"
    "middleclick"
    "jordanbaird-ice"
    "domzilla-caffeine"
    "bambu-studio"
  ];

  programs.fish.enable = true;
  hmUsers.jeslinmx = {
    uid = 501;
    shell = pkgs.fish;
    hmModules =
      (with homeModules; [
        cli-programs
        {
          home.stateVersion = "24.11";
          targets.darwin.search = "DuckDuckGo";
        }
      ])
      ++ (with inputs.private-config.homeModules; [
        ssh-personal-hosts
        ssh-speqtral-hosts
      ]);
  };
}
