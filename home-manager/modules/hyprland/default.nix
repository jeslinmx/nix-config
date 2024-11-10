{ lib, pkgs, ... }: {

  imports = [
    ./waybar.nix
    ./hyprlock.nix
    ./hyprland.nix
    ./hyprshade.nix
  ];

  home.packages = lib.attrValues {
    inherit (pkgs) swww brightnessctl playerctl;
  };

  services = {
    dunst = {
      enable = true;
    };
    udiskie = {
      enable = true;
    };
    ssh-agent.enable = true;
  };

}
