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
      telegram-desktop # https://discourse.nixos.org/t/flatpak-telegram-desktop-desktop-entry-problems/31374
  ];
}
