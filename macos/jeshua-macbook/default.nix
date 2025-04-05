{
  flake,
  lib,
  pkgs,
  ...
}: {
  imports = with flake.nixosModules; [
    base-nix-config
    flake.inputs.home-manager-darwin.darwinModules.home-manager
    flake.inputs.stylix.darwinModules.stylix
    darwin-sudo
    darwin-stylix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  networking.hostName = "jeshua-macbook";
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    casks = [
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
  };
  users.users.jeslinmx = {
    home = "/Users/jeslinmx";
  };
  system.defaults = {
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit flake;};
    backupFileExtension = "hmbak";
    users.jeslinmx = {
      imports =
        (with flake.homeModules; [cli-programs])
        ++ (with flake.inputs.private-config.homeModules; [
          ssh-personal-hosts
          ssh-speqtral-hosts
        ]);
      home.stateVersion = "24.11";
      home.homeDirectory = "/Users/jeslinmx";
      targets.darwin.search = "DuckDuckGo";
    };
  };
}
