{homeModules, pkgs, ...}: {
  imports = with homeModules; [
    aesthetics
    common-programs
    gnome-shell
    colors
  ];

  colors.scheme = "catppuccin-mocha";
  xdg.enable = true;

  home.packages = with pkgs; [
      ### CLI TOOLS ###
      kjv

      ### GRAPHICAL ###
      prismlauncher
      godot_4
  ];
}
