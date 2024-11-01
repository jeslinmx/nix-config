{ config, pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    systemd.setPath.enable = true;
  };
  networking.networkmanager.enable = true;
}
