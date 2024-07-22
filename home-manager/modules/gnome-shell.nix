{
  lib,
  osConfig ? {},
  pkgs,
  nixpkgs-unstable,
  ...
}:
let
  pkgs-unstable = import nixpkgs-unstable { inherit (pkgs) system; };
  extensions = lib.attrValues { inherit (pkgs-unstable.gnomeExtensions)
    appindicator
    autohide-battery
    wallpaper-slideshow
    bluetooth-battery-meter
    blur-my-shell
    caffeine
    clipboard-indicator
    dash-to-panel
    dim-background-windows
    removable-drive-menu
    gtk4-desktop-icons-ng-ding
    middle-click-to-close-in-overview
    quick-settings-tweaker
    syncthing-indicator
    task-widget
    tiling-assistant
    windownavigator
    wtmb-window-thumbnails
  ;};
in lib.mkIf (osConfig.services.xserver.desktopManager.gnome.enable or false) {
  home.packages = extensions;

  dconf.settings = {
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/interface" = {
      enable-animations = true;
      font-antialiasing = "grayscale";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/search-providers" = {
      enabled = ["org.gnome.Contacts.desktop" "org.gnome.Calculator.desktop" "org.gnome.Calendar.desktop" "org.gnome.Characters.desktop"];
      sort-order = ["org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Contacts.desktop" "org.gnome.Calendar.desktop" "org.gnome.Settings.desktop" "org.gnome.Characters.desktop" "org.gnome.Software.desktop" "org.gnome.Calculator.desktop" "org.gnome.Weather.desktop" "org.gnome.Terminal.desktop" "org.gnome.clocks.desktop"];
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      always-on-top = ["<Super><Alt>t"];
      maximize = ["<Super>Up"];
      move-to-workspace-1 = ["<Shift><Control><Super>1"];
      move-to-workspace-2 = ["<Shift><Control><Super>2"];
      move-to-workspace-3 = ["<Shift><Control><Super>3"];
      move-to-workspace-4 = ["<Shift><Control><Super>4"];
      move-to-workspace-last = ["<Shift><Control><Super>End"];
      move-to-workspace-left = ["<Shift><Control><Super>Left"];
      move-to-workspace-right = ["<Shift><Control><Super>Right"];
      switch-applications = ["<Super>Tab"];
      switch-applications-backward = ["<Shift><Super>Tab"];
      switch-input-source = ["<Alt>space"];
      switch-input-source-backward = ["<Shift><Alt>space"];
      switch-to-workspace-1 = ["<Control><Super>1"];
      switch-to-workspace-2 = ["<Control><Super>2"];
      switch-to-workspace-3 = ["<Control><Super>3"];
      switch-to-workspace-4 = ["<Control><Super>4"];
      switch-to-workspace-last = ["<Control><Super>End"];
      switch-to-workspace-left = ["<Control><Super>Left"];
      switch-to-workspace-right = ["<Control><Super>Right"];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/gnome-session" = {
      auto-save-session = true;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      dynamic-workspaces = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 3700;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = ["<Super>i"];
      home = ["<Super>e"];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "hibernate";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = builtins.map (x: x.extensionUuid) extensions;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-saturation = 1.0; # actually desaturation
      icon-size = 16;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/autohide-battery" = {
      hide-on = 95;
    };

    "org/gnome/shell/extensions/azwallpaper" = {
      slideshow-use-absolute-time-for-duration = true;
    };

    "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
      enable-battery-indicator = true;
      enable-battery-level-icon = false;
      enable-battery-level-text = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      enable-all = true;
      opacity = 230;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      override-background-dynamically = true;
      static-blur = false;
    };

    "org/gnome/shell/extensions/caffeine" = {
      countdown-timer = 0;
      duration-timer = 2;
      indicator-position-max = 1;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      disable-down-arrow = true;
      display-mode = 0;
      enable-keybindings = false;
      notify-on-copy = false;
      topbar-preview-size = 10;
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      appicon-margin = 0;
      appicon-padding = 6;
      click-action = "TOGGLE-CYCLE";
      dot-color-dominant = true;
      dot-color-override = false;
      dot-size = 1;
      dot-style-focused = "METRO";
      dot-style-unfocused = "DASHES";
      focus-highlight-dominant = true;
      focus-highlight-opacity = 15;
      hide-overview-on-startup = true;
      hot-keys = true;
      isolate-workspaces = true;
      leftbox-padding = -1;
      middle-click-action = "QUIT";
      multi-monitors = true;
      overview-click-to-exit = true;
      panel-element-positions = let
        value = ''
          [{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]
        '';
      in ''
        {"0":${value},"1":${value},"2":${value},"3":${value}}
      '';
      panel-sizes = let
        value = "36";
      in ''
        {"0":${value},"1":${value},"2":${value},"3":${value}}
      '';
      shift-click-action = "LAUNCH";
      shift-middle-click-action = "QUIT";
      shortcut-previews = false;
      show-showdesktop-delay = 500;
      show-showdesktop-hover = true;
      show-showdesktop-time = 200;
      show-window-previews-timeout = 250;
      showdesktop-button-width = 4;
      status-icon-padding = -1;
      stockgs-force-hotcorner = false;
      stockgs-panelbtn-click-only = false;
      trans-dynamic-anim-target = 1;
      trans-dynamic-distance = 1;
      trans-panel-opacity = 0;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      tray-padding = 6;
      window-preview-animation-time = 100;
      window-preview-padding = 0;
      window-preview-show-title = false;
      window-preview-size = 160;
    };

    "org/gnome/shell/extensions/dim-background-windows" = {
      # saturation = 1.0;
      target-monitor = "primary";
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      input-always-show = true;
    };

    "org/gnome/shell/extensions/task-widget" = {
      hide-completed-tasks = 2; # after a period of time
      hide-empty-completed-task-lists = true;
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      activate-layout0 = [];
      activate-layout1 = [];
      activate-layout2 = [];
      activate-layout3 = [];
      active-window-hint = 0;
      active-window-hint-border-size = 1;
      active-window-hint-color = "rgb(53,132,228)";
      active-window-hint-inner-border-size = 0;
      auto-tile = [];
      center-window = [];
      debugging-free-rects = [];
      debugging-show-tiled-rects = [];
      default-move-mode = 0;
      dynamic-keybinding-behavior = 3;
      enable-advanced-experimental-features = false;
      import-layout-examples = false;
      last-version-installed = 45;
      maximize-with-gap = false;
      move-adaptive-tiling-mod = 3;
      overridden-settings = "{'org.gnome.mutter.edge-tiling': <true>, 'org.gnome.desktop.wm.keybindings.maximize': <['<Super>Up']>, 'org.gnome.desktop.wm.keybindings.unmaximize': <['<Super>Down']>, 'org.gnome.mutter.keybindings.toggle-tiled-left': <['<Super>Left']>, 'org.gnome.mutter.keybindings.toggle-tiled-right': <['<Super>Right']>}";
      restore-window = ["<Super>Down"];
      search-popup-layout = [];
      show-layout-panel-indicator = false;
      single-screen-gap = 10;
      tile-bottom-half = ["<Super>KP_2"];
      tile-bottom-half-ignore-ta = [];
      tile-bottomleft-quarter = ["<Super>KP_1"];
      tile-bottomleft-quarter-ignore-ta = [];
      tile-bottomright-quarter = ["<Super>KP_3"];
      tile-bottomright-quarter-ignore-ta = [];
      tile-edit-mode = [];
      tile-left-half = ["<Super>Left" "<Super>KP_4"];
      tile-left-half-ignore-ta = [];
      tile-maximize = ["<Super>Up" "<Super>KP_5"];
      tile-maximize-horizontally = [];
      tile-maximize-vertically = [];
      tile-right-half = ["<Super>Right" "<Super>KP_6"];
      tile-right-half-ignore-ta = [];
      tile-top-half = ["<Super>KP_8"];
      tile-top-half-ignore-ta = [];
      tile-topleft-quarter = ["<Super>KP_7"];
      tile-topleft-quarter-ignore-ta = [];
      tile-topright-quarter = ["<Super>KP_9"];
      tile-topright-quarter-ignore-ta = [];
      toggle-always-on-top = [];
      toggle-tiling-popup = [];
      window-gap = 10;
    };

    "org/gnome/shell/extensions/window-thumbnails" = {
      hide-focused = true;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
  };
}
