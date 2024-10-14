{ pkgs, ... }: {
  programs = {
    waybar = {
      enable = true;
    };
    rofi = {
      enable = true;
      package = pkgs.rofi.override { rofi-unwrapped = pkgs.rofi-wayland-unwrapped; };
    };
  };
  home.packages = [ pkgs.swww ];
}
