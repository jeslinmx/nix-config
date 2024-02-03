{homeModules, ...}: {
  imports = with homeModules; [
    aesthetics
    programs
    gnome-shell
    kitty
  ];

  xdg.enable = true;
}
