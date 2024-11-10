{config, lib, pkgs, ...}@args: let
  common = (import ./common.nix) args;
  inherit (common) brightness-command mute-command volume-command scrot-base-command;
in {
  wayland.windowManager.hyprland = let cfg = config.wayland.windowManager.hyprland;
  in {
    enable = true;
    systemd = {
      enableXdgAutostart = true;
      variables = [ "--all" ]; # makes systemd bring all env vars into the dbus session
    };
    sourceFirst = false; # put source statements at end
    settings = let
      directionKeys = [ [ "up" "k" ] [ "down" "j" ] [ "left" "h" ] [ "right" "l" ] ];
      directions = [ "u" "d" "l" "r" ];
      produceBinds = { mod ? "SUPER", keys ? directionKeys, dispatcher, args ? directions }:
        lib.concatMap (
          { fst, snd }: lib.map
            (key: lib.concatStringsSep ", " [ mod key dispatcher snd ])
            (if lib.isList fst then fst else lib.singleton fst)
        ) (lib.zipLists keys args);
    in {

      # source = [ "~/.config/hypr/custom.conf" ];

      "$terminal" = "${config.programs.kitty.package}/bin/kitty --single-instance";
      "$menu" = "${config.programs.rofi.package}/bin/rofi";

      general = {
        gaps_in = 5;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = let inherit (config.lib.stylix.colors) base0C base0D;
          in lib.mkForce "rgba(${base0C}ff) rgba(${base0D}ff) 45deg";
        # inactive_border is set by stylix
        resize_on_border = true;
        allow_tearing = true; # master switch
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        drop_shadow = false;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur.enabled = false;
      };

      group = let inherit (config.lib.stylix.colors) base09 base0A base0C base0D;
      in {
        # not yet available in 0.44.1
        # drag_into_group = 2; # only drag into group via groupbar
        "col.border_active" = lib.mkForce cfg.settings.general."col.active_border";
        # border_inactive is set by stylix
        "col.border_locked_active" = lib.mkForce "rgba(${base0A}ff) rgba(${base09}ff) 45deg";
        "col.border_locked_inactive" = cfg.settings.general."col.inactive_border";
        groupbar = {
          "col.active" = "rgba(${base0D}ff)";
          "col.inactive" = cfg.settings.group."col.border_inactive";
          "col.locked_active" = "rgba(${base0A}ff)";
          "col.locked_inactive" = cfg.settings.group."col.border_locked_inactive";
        };
      };

      dwindle = {
        pseudotile = true; # master switch
        smart_split = true;
      };

      misc = {
        disable_hyprland_logo = true; # disable default wallpapers
        enable_swallow = true; # replace swallow_regex windows with child process
        swallow_regex = "^(kitty)$";
        middle_click_paste = false;
        new_window_takes_over_fullscreen = 2; # kick out of fullscreen if opening new window
      };

      input.touchpad.natural_scroll = true;
      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_direction_lock = false;
      };

      monitor = [
        "eDP-1,preferred,0x0,1"
        "desc:VIE PF24HD S.IPS,preferred,auto-left,1" # home monitor
        ",preferred,auto,auto"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user start hyprpolkitagent"
        "${config.programs.waybar.package}/bin/waybar &"
        "${pkgs.swww}/bin/swww-daemon & ${pkgs.swww}/bin/swww img ${config.stylix.image}"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "SWWW_TRANSITION,any"
        "SWWW_TRANSITION_FPS,60"
      ];

      workspace = [
        "f[1], gapsout:0"
      ];

      windowrulev2 = let
        rule = dispatchers: conditions: lib.map (d: "${d}, ${conditions}") dispatchers;
      in [
        "bordersize 0, onworkspace:f[1]"
        "rounding 0, onworkspace:f[1]"
        "suppressevent maximize, class:.*"
        "float, class:(org.telegram.desktop) title:(Media viewer)"
      ]
      ++ (rule
        ["float" "pin" "noinitialfocus" "size 20% 20%" "move 100%-w-20 100%-w-20"]
        "class:(firefox), title:(Picture-in-Picture)"
      );

      ### BINDS ###

      bind = [
        "SUPER, RETURN, togglesplit"
        "SUPER, SPACE, exec, $menu -show drun"
        "CTRL SUPER, SPACE, exec, $menu -show run"
        "SUPER, C, exec, $toggleShaders"
        "SHIFT SUPER, C, exec, $disableShaders"
        "SUPER, F11, fullscreen, 1"
        "SUPER, F12, exit"
        "SUPER, T, exec, $terminal"
        "SUPER, Q, killactive"
        "SUPER, E, exec, $fileManager"
        "SUPER, F, togglefloating"
        "SUPER, F, centerwindow"
        "SUPER, P, pseudo" # dwindle
        "SUPER, G, togglegroup"
        "CTRL SUPER, G, lockactivegroup, toggle"
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER, tab, exec, $menu -show window"
        "SUPER, escape, exec, hyprlock"
        ", XF86AudioMute, exec, ${mute-command "@DEFAULT_AUDIO_SINK@"}"
        "ALT, XF86AudioMute, exec, ${mute-command "@DEFAULT_AUDIO_SOURCE@"}"
        ", XF86AudioMicMute, exec, ${mute-command "@DEFAULT_AUDIO_SOURCE@"}"
      ]
      # switch focus with SUPER + direction
      ++ (produceBinds { dispatcher = "movefocus"; })
      # move windows with SHIFT + SUPER + direction
      ++ (produceBinds { mod = "SHIFT SUPER"; dispatcher = "movewindow"; })
      # swap windows with CTRL + SHIFT + SUPER + direction
      ++ (produceBinds { mod = "CTRL SHIFT SUPER"; dispatcher = "swapwindow"; })
      # move window into groups with CTRL + SUPER + direction
      ++ (produceBinds { mod = "CTRL SUPER"; dispatcher = "movewindoworgroup"; })
      # switch workspaces with SUPER + number
      ++ (produceBinds {
        keys = lib.map builtins.toString (lib.range 1 9) ++ ["0"];
        dispatcher = "workspace";
        args = lib.map builtins.toString (lib.range 1 10);
      })
      # move window to workspaces with SHIFT + SUPER + number/S
      ++ (produceBinds {
        mod = "SHIFT SUPER";
        keys = lib.map builtins.toString (lib.range 1 9) ++ ["0" "S"];
        dispatcher = "movetoworkspace";
        args = lib.map builtins.toString (lib.range 1 10) ++ ["special:magic"];
      })
      # silently move window to workspaces with CTRL + SHIFT + SUPER + number/S
      ++ (produceBinds {
        mod = "CTRL SHIFT SUPER";
        keys = lib.map builtins.toString (lib.range 1 9) ++ ["0" "S"];
        dispatcher = "movetoworkspacesilent";
        args = lib.map builtins.toString (lib.range 1 10) ++ ["special:magic"];
      })
      ++ [
        ", print, exec, ${scrot-base-command} --clipboard-only --mode output"
        "ALT, print, exec, ${scrot-base-command} --clipboard-only --mode window"
        "CTRL, print, exec, ${scrot-base-command} --clipboard-only --mode region"
        "SUPER, print, exec, ${scrot-base-command} --mode output"
        "ALT SUPER, print, exec, ${scrot-base-command} --mode window"
        "CTRL SUPER, print, exec, ${scrot-base-command} --mode region"
      ];

      binde = [
        # Switch within groups with CTRL + [SHIFT] + SUPER + tab
        "CTRL SUPER, tab, changegroupactive, f"
        "CTRL SHIFT SUPER, tab, changegroupactive, b"
      ]
      # volume keys; use ALT to target mic, use CTRL for fine adjustment
      ++ (lib.concatMap ({mod, dev, amt}: [
        "${mod}, XF86AudioRaiseVolume, exec, ${volume-command dev amt}"
        "${mod}, XF86AudioLowerVolume, exec, ${volume-command dev (-amt)}"
      ]) [
        { mod = ""; dev = "@DEFAULT_AUDIO_SINK@"; amt = 5; }
        { mod = "CTRL"; dev = "@DEFAULT_AUDIO_SINK@"; amt = 1; }
        { mod = "ALT"; dev = "@DEFAULT_AUDIO_SOURCE@"; amt = 5; }
        { mod = "CTRL ALT"; dev = "@DEFAULT_AUDIO_SOURCE@"; amt = 1; }
      ])
      # brightness keys
      ++ [
        ",XF86MonBrightnessUp,   exec, ${brightness-command 10}"
        ",XF86MonBrightnessDown, exec, ${brightness-command (-10)}"
      ]
      # resize windows with ALT + SUPER + direction
      ++ (produceBinds {
        mod = "ALT SUPER";
        dispatcher = "resizeactive";
        args = let dist = "25"; in [ "0 -${dist}" "0 ${dist}" "-${dist} 0" "${dist} 0" ];
      })
      # fine resize windows with CTRL + ALT + SUPER + direction
      ++ (produceBinds {
        mod = "CTRL ALT SUPER";
        dispatcher = "resizeactive";
        args = let dist = "1"; in [ "0 -${dist}" "0 ${dist}" "-${dist} 0" "${dist} 0" ];
      });

      bindm = [
        "SUPER, z, movewindow"
        "SUPER ALT, z, resizewindow"
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

    };
  };

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi.override { rofi-unwrapped = pkgs.rofi-wayland-unwrapped; };
    };
  };

}
