{ osConfig, outputs, ... }: {

  home.stateVersion = osConfig.system.stateVersion;

  imports = with outputs.modules.home; [
    aesthetics
    programs
    gnome-shell
    kitty
  ];

  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
  };

  xdg.enable = true;
  services.syncthing.enable = true;
}
