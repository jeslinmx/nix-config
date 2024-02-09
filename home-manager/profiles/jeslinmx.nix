{homeModules, ...}: {
  imports = with homeModules; [
    aesthetics
    firefox
    programs
    gnome-shell
    kitty
  ];

  xdg.enable = true;
}
