{ config, pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      systemd.setPath.enable = true;
    };
    hyprlock.enable = true;
    nm-applet = {
      enable = true;
      indicator = false;
    };
  };
  networking.networkmanager.enable = true;
  services.logind = {
    powerKey = "hibernate";
    lidSwitchDocked = "suspend";
  };
}
