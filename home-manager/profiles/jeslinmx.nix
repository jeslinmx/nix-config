{homeModules, pkgs, ...}: {
  imports = with homeModules; [
    aesthetics
    cli-programs
    gui-programs
    gnome-shell
    colors
  ];

  colors.scheme = "catppuccin-mocha";
  xdg.enable = true;

  services = {
    syncthing.enable = true;
  };

  home.packages = with pkgs; [
      ### CLI TOOLS ###
      kjv

      ### GRAPHICAL ###
      prismlauncher
      godot_4
  ];
}
