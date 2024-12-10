{ lib, pkgs, ... }: {

  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hyprland.nix
    ./hyprshade.nix
  ];

  home.packages = lib.attrValues {
    inherit (pkgs) swww brightnessctl playerctl;
  };

  services = {
    swaync = {
      enable = true;
    };
    udiskie = {
      enable = true;
    };
    ssh-agent.enable = true;
  };

}
