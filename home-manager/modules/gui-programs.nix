{
  homeModules,
  pkgs,
  nixpkgs-unstable,
  ...
}: let
    nixpkgs-config = {inherit (pkgs) system config;};
    unstable = import nixpkgs-unstable nixpkgs-config;
  in
{
  imports = with homeModules; [
    kitty
    firefox
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
    ];
}
