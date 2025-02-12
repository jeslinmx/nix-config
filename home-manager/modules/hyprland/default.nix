{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hyprland.nix
    ./wallpaper-cycle.nix
  ];

  home.packages = lib.attrValues {
    inherit (pkgs) swww brightnessctl playerctl;
  };

  services = {
    network-manager-applet.enable = true;
    udiskie.enable = true;
    udiskie.settings.program_options.file_manager = "xdg-open";
    ssh-agent.enable = true;
    swaync = {
      enable = true;
      settings = {
        control-center-margin-top = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-bottom = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-left = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        control-center-margin-right = config.wayland.windowManager.hyprland.settings.general.gaps_out;
        hide-on-clear = true;
      };
    };
  };

  systemd.user.services = {
    network-manager-applet.Unit.After = ["graphical-session.target"];
    udiskie.Unit.After = ["graphical-session.target"];
    ssh-agent = {
      Unit.Before = ["graphical-session-pre.target"];
      Service = {
        ExecStartPost = "systemctl --user set-environment \"SSH_AUTH_SOCK=%t/ssh-agent\"";
        ExecStopPost = "systemctl --user unset-environment SSH_AUTH_SOCK";
      };
    };
  };
}
