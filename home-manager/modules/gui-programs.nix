{
  homeModules,
  pkgs,
  ...
}: let
  in
{
  imports = builtins.attrValues {
    inherit (homeModules) firefox kitty;
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
  };

  # unnixed stuff
  home.packages = builtins.attrValues { inherit (pkgs)
    wl-clipboard
    virt-manager
    helvum
    beeper
  ;};
}
