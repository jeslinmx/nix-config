{ hostConfig, pkgs, ... }: {

  home.stateVersion = hostConfig.system.stateVersion;

  imports = [
    ./packages.nix
    ./vivaldi-dark-mode.nix
    ./gnome-shell.nix
  ];

  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
    };
  };
  xdg.enable = true;
  services.syncthing.enable = true;
}
