{...}: {
  config,
  lib,
  pkgs,
  ...
} @ args: let
  common = (import ./common.nix) args;
  inherit (common) brightness-command mute-command;
in {
  programs.waybar = {
    enable = true;
    style = let
      inherit (config.lib.stylix.colors) base00 base01 base05 base0D;
    in
      lib.mkForce ''
        window#waybar, tooltip {
            background: #${base00};
            color: #${base05};
            font-family: "${config.stylix.fonts.sansSerif.name}";
            font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
        }
        .module {
          padding: 0 5px;
        }
        .drawer-child {
          background-color: #${base01};
        }
        tooltip {
            border-color: #${base0D};
            border-radius: ${builtins.toString config.wayland.windowManager.hyprland.settings.decoration.rounding}px;
            border-width: ${builtins.toString config.wayland.windowManager.hyprland.settings.general.border_size}px;
        }
        tooltip label {
            font-family: "${config.stylix.fonts.monospace.name}";
        }
        #workspaces button {
            border-radius: 0;
            border-bottom: 2px solid transparent;
        }
        #workspaces button.focused,
        #workspaces button.active {
            border-bottom-color: #${base0D};
        }
      '';
    settings = let
      braille-scale = {
        "0" = "   ";
        "5" = "  ⡀";
        "10" = " ⢀⡀";
        "15" = " ⣀⡀";
        "20" = "⢀⣀⡀";
        "25" = "⣀⣀⡀";
        "30" = "⣀⣀⡄";
        "35" = "⣀⣠⡄";
        "40" = "⣀⣤⡄";
        "45" = "⣠⣤⡄";
        "50" = "⣤⣤⡄";
        "55" = "⣤⣤⡆";
        "60" = "⣤⣴⡆";
        "65" = "⣤⣶⡆";
        "70" = "⣴⣶⡆";
        "75" = "⣶⣶⡆";
        "80" = "⣶⣶⡇";
        "85" = "⣶⣾⡇";
        "90" = "⣶⣿⡇";
        "95" = "⣾⣿⡇";
        "100" = "⣿⣿⡇";
      };
      generate-states = lib.mapAttrs (val: _: lib.toInt val);
      generate-formats = name-pre: fmt:
        lib.mapAttrs' (
          val: sym: {
            name = "${name-pre}${val}";
            value = builtins.replaceStrings ["{}"] [sym] fmt;
          }
        );
    in [
      rec {
        position = "top";
        modules-left = [
          "group/clock"
          # "hyprland/submap"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "group/mpris"
        ];
        modules-right = [
          # "hyprland/language"
          "group/system"
          "group/bluetooth"
          "group/network"
          "pulseaudio"
          "privacy"
          "tray"
          "custom/swaync"
        ];

        "group/clock" = {
          modules = ["clock" "clock#date"];
          orientation = "inherit";
          drawer = {};
        };
        clock = {
          format = "{:%H:%M}";
        };
        "clock#date" = {
          format = "{:%a %b %d}";
          tooltip-format = "{calendar}";
          actions = {
            on-click-right = "mode";
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
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
            "class<org.telegram.desktop>" = "";
            "class<org.keepassxc.KeePassXC>" = "󰟵";
            "class<net.ankiweb.Anki>" = "󰘸";
            "class<com.github.rafostar.Clapper>" = "";
            "class<org.gnome.Loupe>" = "";
            "class<org.pwmt.zathura>" = "";
            "class<Minecraft.*>" = "󰍳";
            "class<steam>" = "";
            "class<vesktop>" = "";
            "class<obsidian>" = "";
            "class<teams-for-linux>" = "󰊻";
            "title<nvim .*>" = "";
            "title<lazygit .*>" = "󰊢";
            "title<Yazi .*>" = "󰉋";
            "title<tmux .*>" = "";
            "title<termshark .*>" = "󱙳";
            "title<btop .*>" = "";
          };
          window-rewrite-default = "";
        };
        "hyprland/window" = {
          separate-outputs = true;
        };

        "group/mpris" = {
          modules = ["mpris" "mpris#extra"];
          orientation = "inherit";
          drawer = {};
        };
        mpris = {
          format = "{player_icon} {status_icon} {title}";
          format-stopped = "";
          player-icons = {firefox = "󰈹";};
          status-icons = {
            paused = "";
            playing = "󰎇";
          };
          title-len = 60;
          tooltip = false;
          ignored-players = ["Blanket"];
        };
        "mpris#extra" = {
          format = "- {dynamic}";
          dynamic-order = ["artist" "position" "length"];
          inherit (mpris) format-stopped tooltip ignored-players;
        };

        tray = {spacing = 8;};

        "group/bluetooth" = {
          modules = ["bluetooth" "bluetooth#extra"];
          orientation = "inherit";
          drawer = {transition-left-to-right = false;};
        };
        bluetooth = {
          format-connected = "󰂱{num_connections}";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-on = "";
          on-click = lib.getExe pkgs.rofi-bluetooth;
        };
        "bluetooth#extra" = {
          format-connected = "{device_alias}";
          format-connected-battery = "󰥉 {device_battery_percentage}% {device_alias}";
          tooltip-format = "{controller_alias} ({controller_address}) {status}\n{device_enumerate}";
          tooltip-format-enumerate-connected = "󰥉 {device_battery_percentage}% {device_alias} ({device_address})";
          inherit (bluetooth) on-click;
        };

        "group/network" = {
          modules = ["network" "network#extra"];
          orientation = "inherit";
          drawer = {transition-left-to-right = false;};
        };
        network = let
          inherit (config.lib.stylix.colors) base04;
        in {
          format-disconnected = "<span color='#${base04}'>󰌙</span>";
          format-ethernet = "";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          format-wifi = "{icon} {essid}";
          tooltip = false;
          interval = 10;
        };
        "network#extra" = {
          format = "󰩠 {ipaddr}";
          tooltip-format = "{ifname} {bandwidthUpBits} {bandwidthDownBits}\n󰩠 {ipaddr}/{cidr}\n󱇢 {gwaddr}";
          tooltip-format-wifi = "{ifname} {bandwidthUpBits} {bandwidthDownBits}\n󰐻 {essid} 󰣺 {signalStrength}%\n󰩠 {ipaddr}/{cidr}\n󱇢 {gwaddr}";
          inherit (network) interval;
        };

        privacy.icon-size = config.stylix.fonts.sizes.desktop;
        pulseaudio = let
          inherit (config.lib.stylix.colors) base04 base08 base0B base0C;
        in {
          format = "<span color='#${base0B}'>󰕾 {volume}%</span> {format_source}";
          format-bluetooth = "<span color='#${base0C}'>󰂰 {volume}%</span> {format_source}";
          format-bluetooth-muted = "<span color='#${base04}'>󰂲 {volume}%</span> {format_source}";
          format-muted = "<span color='#${base04}'>󰝟 {volume}%</span> {format_source}";
          format-source = "<span color='#${base08}'>󰍬 {volume}%</span>";
          format-source-muted = "<span color='#${base04}'>󰍭 {volume}%</span>";
          on-click = mute-command "@DEFAULT_AUDIO_SINK@";
          on-click-middle = lib.getExe pkgs.pavucontrol;
          on-click-right = mute-command "@DEFAULT_AUDIO_SOURCE@";
          reverse-scrolling = true;
        };

        "group/system" = {
          modules = ["group/sysinfo" "temperature" "disk"];
          orientation = "inherit";
          drawer = {transition-left-to-right = false;};
        };
        "group/sysinfo" = {
          modules = ["memory" "cpu" "battery"];
          orientation = "inherit";
        };
        battery =
          {
            states = generate-states braille-scale;
            format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-time = "{H}:{m}";
            tooltip-format = "{capacity}% - {timeTo}\nCurrent power draw: {power:.2f}W";
          }
          // (generate-formats "format-" "{}{icon}" braille-scale)
          // (generate-formats "format-charging-" "{}󰂄" braille-scale);
        cpu =
          {states = generate-states braille-scale;}
          // (generate-formats "format-" "{}" braille-scale);
        memory =
          {
            states = generate-states braille-scale;
            tooltip-format = "RAM: {used}/{total} GiB ({percentage}%)\nSwap: {swapUsed}/{swapTotal} GiB ({swapPercentage}%)";
          }
          // (generate-formats "format-" "{}" braille-scale);
        disk =
          {states = generate-states braille-scale;}
          // (generate-formats "format-" "{}" braille-scale);
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];
          tooltip = false;
        };

        "custom/swaync" = let
          inherit (config.lib.stylix.colors) base04 base0A;
        in {
          exec = "swaync-client -swb";
          exec-if = "which swaync-client";
          escape = true;
          return-type = "json";
          format = "{icon}<sup>{}</sup>";
          format-icons = {
            dnd-inhibited-none = "<span color='#${base04}'>󰪑</span>";
            dnd-inhibited-notification = "<span color='#${base04}'>󰪑</span>";
            dnd-none = "<span color='#${base04}'>󰪑</span>";
            dnd-notification = "<span color='#${base04}'>󰪑</span>";
            inhibited-none = "<span color='#${base04}'>󰪑</span>";
            inhibited-notification = "<span color='#${base04}'>󰪑</span>";
            none = "󰂜";
            notification = "<span color='#${base0A}'>󰂚</span>";
          };
          tooltip = false;
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
        };
      }
    ];
  };
}
