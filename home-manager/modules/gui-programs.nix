{
  homeModules,
  pkgs,
  ...
}: let
  in
{
  imports = with homeModules; [
    firefox
    kitty
  ];

  programs = {
    firefox.enable = true;
    kitty.enable = true;
  };

  # unnixed stuff
  home.packages = with pkgs; [
      wl-clipboard
      virt-manager
      helvum
      beeper
    ];
}
