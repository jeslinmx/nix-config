{lib, pkgs, ...}@args: let
  common = (import ./common.nix) args;
  inherit (common) brightness-command mute-command;
in {
  programs.waybar = {
    enable = true;
    settings = [{
      position = "bottom";
      modules-left = ["clock" "hyprland/submap" "hyprland/workspaces" "hyprland/window"];
      modules-center = ["mpris" "pulseaudio"];
      modules-right = ["backlight" "bluetooth" "network" "group/sysinfo" "privacy" "hyprland/language" "tray"];
      clock = {
        actions = {
          on-click-right = "mode";
          on-scroll-down = "shift_down";
          on-scroll-up = "shift_up";
        };
        format = "󱑍 {:%H:%M}";
        tooltip-format = "<small>{calendar}</small>";
      };
      "hyprland/submap" = {
        always-on = true;
        default-submap = "";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        format = "<sup>{icon}</sup>{windows}";
        format-icons = {
          special = "";
          urgent = "";
        };
        format-window-separator = " ";
        show-special = true;
        window-rewrite = {
          "class<firefox>" = "󰈹";
          "class<kitty>" = "";
          "class<org.telegram.desktop>" = "";
          "class<steam>" = "";
          "class<teams-for-linux>" = "󰊻";
        };
        window-rewrite-default = "";
      };
      "hyprland/window" = {
        icon = true;
        separate-outputs = true;
      };

      mpris = {
        artist-len = 15;
        format = "{status_icon} {title} - {artist} {player_icon}";
        format-stopped = "";
        player-icons = {firefox = "󰈹";};
        status-icons = {
          paused = "";
          playing = "󰎇";
        };
        title-len = 30;
      };
      pulseaudio = {
        format = "󰕾 {volume}% {format_source}";
        format-bluetooth = "󰂰 {volume}% {format_source}";
        format-bluetooth-muted = "󰂲 {volume}% {format_source}";
        format-muted = "󰝟 {volume}% {format_source}";
        format-source = "󰍬 {volume}%";
        format-source-muted = "󰍭 {volume}%";
        on-click = mute-command "@DEFAULT_AUDIO_SINK@";
        on-click-middle = "${mute-command "@DEFAULT_AUDIO_SOURCE@"} && ${mute-command "@DEFAULT_AUDIO_SINK@"}";
        on-click-right = mute-command "@DEFAULT_AUDIO_SOURCE@";
        reverse-scrolling = true;
      };

      backlight = {
        format = "{icon}";
        format-icons = ["�󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
        on-scroll-up = brightness-command 10;
        on-scroll-down = brightness-command (-10);
        reverse-scrolling = true;
        tooltip = false;
      };
      bluetooth = {
        format-connected = "󰂱<sup>{num_connections}</sup> {device_alias}";
        format-connected-battery = "󰂱<sup>{num_connections}</sup> 󰥉 {device_battery_percentage}% {device_alias}";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-on = "";
        max-length = 20;
        tooltip-format = "{controller_alias} ({controller_address}) {status}\n{device_enumerate}";
        tooltip-format-enumerate-connected = "󰥉 {device_battery_percentage}% {device_alias} ({device_address})";
        on-click = "${lib.getExe pkgs.overskride}";
      };
      network = {
        format-disconnected = "󰌙";
        format-ethernet = " {ipaddr}";
        format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
        format-wifi = "{icon} {ipaddr}";
        interval = 10;
        tooltip-format = "{ifname} {bandwidthUpBits} {bandwidthDownBits}\n {ipaddr}/{cidr}\n󱇢 {gwaddr}";
        tooltip-format-wifi = "{ifname} {bandwidthUpBits} {bandwidthDownBits}\n󰐻 {essid} 󰣺 {signalStrength}%\n {ipaddr}/{cidr}\n󱇢 {gwaddr}";
      };
      "group/sysinfo" = {
        drawer = {
          click-to-reveal = true;
          transition-left-to-right = false;
        };
        modules = ["battery" "cpu" "load" "memory" "disk" "temperature"];
        orientation = "inherit";
      };
      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        format-time = "{H}:{m}";
        tooltip-format = "{timeTo}\nCurrent power draw: {power}";
      };
      tray = {spacing = 8;};
    }];
  };
}
