{ config, lib, pkgs, ... }: {

  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hyprland.nix
  ];

  home.packages = lib.attrValues {
    inherit (pkgs) swww brightnessctl playerctl;
  };

  services = {
    swaync = {
      enable = true;
      settings = {
        control-center-margin-top = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-bottom = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-left = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-right = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        fit-to-screen = false;
        hide-on-clear = true;
      };
    };
    udiskie = {
      enable = true;
    };
    ssh-agent.enable = true;
  };

}
