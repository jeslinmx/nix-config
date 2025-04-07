{
  flake,
  pkgs,
  ...
}: {
  imports =
    (with flake.inputs; [
      stylix.darwinModules.stylix
    ])
    ++ (with flake.darwinModules; [
      sudo
      stylix
      homebrew
      home-manager-users
      macos-desktop
    ])
    ++ (with flake.nixosModules; [
      base-nix-config
    ]);

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
  ];

  programs.fish.enable = true;
  hmUsers.jeslinmx = {
    uid = 501;
    shell = pkgs.fish;
    hmModules =
      (with flake.homeModules; [
        cli-programs
        {
          home.stateVersion = "24.11";
          targets.darwin.search = "DuckDuckGo";
        }
      ])
      ++ (with flake.inputs.private-config.homeModules; [
        ssh-personal-hosts
        ssh-speqtral-hosts
      ]);
  };
}
