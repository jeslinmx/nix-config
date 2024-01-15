{ hostConfig, ... }: {

  home.stateVersion = hostConfig.system.stateVersion;

  imports = [
    ./aesthetics.nix
    ./programs.nix
    ./gnome-shell.nix
    ./kitty.nix
  ];

  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
  };

  xdg.enable = true;
  services.syncthing.enable = true;
}
