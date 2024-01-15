{ lib, hostConfig, pkgs, ... }: lib.mkIf hostConfig.services.xserver.desktopManager.gnome.enable {
  home.packages = with pkgs; with pkgs.gnome; with pkgs.gnomeExtensions; [
    gnome-extension-manager
    dconf-editor
    file-roller
    simple-scan
    gnome-software

    ### EXTENSIONS ###
    appindicator
    autohide-battery
    blur-my-shell
    caffeine
    clipboard-indicator
    dash-to-panel
    date-menu-formatter
    dim-background-windows
    removable-drive-menu
    desktop-icons-ng-ding
    just-perfection
    media-controls
    middle-click-to-close-in-overview
    next-up
    quick-settings-tweaker
    rounded-window-corners
    space-bar
    syncthing-indicator
    task-widget
    tiling-assistant
    user-themes
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      document-font-name = "Cantarell 10";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Cantarell 10";
      locate-pointer = false;
      monospace-font-name = "Cascadia Code 8";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/notifications" = {
      show-banners = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/search-providers" = {
      enabled = [ "org.gnome.Contacts.desktop" "org.gnome.Calculator.desktop" "org.gnome.Calendar.desktop" "org.gnome.Characters.desktop" ];
      sort-order = [ "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Contacts.desktop" "org.gnome.Calendar.desktop" "org.gnome.Settings.desktop" "org.gnome.Characters.desktop" "org.gnome.Software.desktop" "org.gnome.Calculator.desktop" "org.gnome.Weather.desktop" "org.gnome.Terminal.desktop" "org.gnome.clocks.desktop" ];
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      maximize = [ "<Super>Up" ];
      move-to-workspace-1 = [ "<Shift><Control><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Control><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Control><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Control><Super>4" ];
      move-to-workspace-last = [ "<Shift><Control><Super>End" ];
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Alt>space" ];
      switch-input-source-backward = [ "<Shift><Alt>space" ];
      switch-to-workspace-1 = [ "<Control><Super>1" ];
      switch-to-workspace-2 = [ "<Control><Super>2" ];
      switch-to-workspace-3 = [ "<Control><Super>3" ];
      switch-to-workspace-4 = [ "<Control><Super>4" ];
      switch-to-workspace-last = [ "<Control><Super>End" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      action-middle-click-titlebar = "none";
      button-layout = "appmenu:minimize,maximize,close";
      mouse-button-modifier = "<Super>";
      titlebar-font = "Cantarell Bold 10";
    };

    "org/gnome/gnome-session" = {
      auto-save-session = true;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = false;
      overlay-key = "Super_L";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 4700;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "<Super>i" ];
      custom-keybindings = [];
      home = [ "<Super>e" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      power-button-action = "hibernate";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "autohide-battery@sitnik.ru"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "dash-to-panel@jderose9.github.com"
        "date-menu-formatter@marcinjakubowski.github.com"
        "dim-background-windows@stephane-13.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "gtk4-ding@smedius.gitlab.com"
        "just-perfection-desktop@just-perfection"
        "mediacontrols@cliffniff.github.com"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "next-up@artisticat1.github.com"
        "quick-settings-tweaks@qwreey"
        "rounded-window-corners@yilozt"
        "space-bar@luchrioh"
        "syncthing@gnome.2nv2u.com"
        "task-widget@juozasmiskinis.gitlab.io"
        "tiling-assistant@leleat-on-github"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-saturation = 1.0;
      icon-size = 16;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.6;
      color-and-noise = false;
      hacks-level = 3;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      style-dialogs = 1;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      blur-on-overview = false;
      customize = false;
      enable-all = false;
      opacity = 230;
      sigma = 30;
      whitelist = [ "kitty" ];
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
      blur-original-panel = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      style-components = 3;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      customize = false;
      override-background = false;
      override-background-dynamically = false;
      static-blur = false;
      style-panel = 0;
      unblur-in-overview = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      blur = true;
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
      animate-appicon-hover = false;
      appicon-margin = 0;
      appicon-padding = 6;
      available-monitors = [ 0 ];
      click-action = "CYCLE-MIN";
      dot-color-dominant = true;
      dot-color-override = false;
      dot-color-unfocused-different = false;
      dot-position = "BOTTOM";
      dot-size = 1;
      dot-style-focused = "CILIORA";
      dot-style-unfocused = "DASHES";
      enter-peek-mode-timeout = 50;
      focus-highlight = true;
      focus-highlight-dominant = true;
      focus-highlight-opacity = 10;
      group-apps = true;
      group-apps-label-font-color = "#dddddd";
      group-apps-label-font-color-minimized = "#dddddd";
      group-apps-label-font-size = 11;
      group-apps-label-font-weight = "normal";
      group-apps-label-max-width = 100;
      group-apps-underline-unfocused = true;
      group-apps-use-fixed-width = true;
      group-apps-use-launchers = false;
      hide-overview-on-startup = true;
      hot-keys = true;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = false;
      intellihide-behaviour = "FOCUSED_WINDOWS";
      intellihide-close-delay = 600;
      intellihide-hide-from-windows = true;
      intellihide-key-toggle = [];
      intellihide-key-toggle-text = "";
      intellihide-show-in-fullscreen = true;
      intellihide-use-pressure = true;
      isolate-workspaces = true;
      leave-timeout = 200;
      leftbox-padding = -1;
      leftbox-size = 12;
      middle-click-action = "QUIT";
      multi-monitors = false;
      overview-click-to-exit = true;
      panel-anchors = ''
        {"0":"MIDDLE","1":"MIDDLE"}
      '';
      panel-element-positions = ''
        {"0":[{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"1":[{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
      '';
      panel-lengths = ''
        {"0":100,"1":100}
      '';
      panel-positions = ''
        {"0":"BOTTOM","1":"BOTTOM"}
      '';
      panel-sizes = ''
        {"0":32,"1":32}
      '';
      preview-custom-opacity = 0;
      preview-use-custom-opacity = true;
      scroll-panel-action = "CYCLE_WINDOWS";
      secondarymenu-contains-showdetails = true;
      shift-click-action = "LAUNCH";
      shift-middle-click-action = "MINIMIZE";
      shortcut = [ "<Super>q" ];
      shortcut-previews = true;
      shortcut-text = "<Super>q";
      show-appmenu = false;
      show-apps-icon-file = "";
      show-favorites = true;
      show-running-apps = true;
      show-showdesktop-delay = 500;
      show-showdesktop-hover = true;
      show-window-previews = true;
      show-window-previews-timeout = 500;
      showdesktop-button-width = 2;
      status-icon-padding = 6;
      stockgs-force-hotcorner = false;
      stockgs-keep-top-panel = false;
      stockgs-panelbtn-click-only = false;
      trans-bg-color = "#181825";
      trans-dynamic-anim-target = 1.0;
      trans-dynamic-anim-time = 300;
      trans-dynamic-behavior = "MAXIMIZED_WINDOWS";
      trans-dynamic-distance = 0;
      trans-gradient-bottom-opacity = 0.5;
      trans-panel-opacity = 0.0;
      trans-use-custom-bg = true;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      tray-padding = 6;
      tray-size = 12;
      window-preview-animation-time = 200;
      window-preview-fixed-y = true;
      window-preview-hide-immediate-click = true;
      window-preview-padding = 8;
      window-preview-show-title = false;
      window-preview-size = 160;
      window-preview-title-font-size = 12;
      window-preview-title-position = "BOTTOM";
      window-preview-use-custom-icon-size = true;
    };

    "org/gnome/shell/extensions/date-menu-formatter" = {
      apply-all-panels = false;
      font-size = 9;
      pattern = "dd/MM kk:mm";
      remove-messages-indicator = false;
    };

    "org/gnome/shell/extensions/dim-background-windows" = {
      brightness = 0.8;
      dimming-enabled = true;
      saturation = 1.0;
      toggle-shortcut = [ "<Super>g" ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      activities-button = true;
      alt-tab-small-icon-size = 0;
      alt-tab-window-preview-size = 0;
      animation = 1;
      app-menu = true;
      app-menu-icon = true;
      app-menu-label = true;
      background-menu = true;
      calendar = true;
      clock-menu = true;
      clock-menu-position = 0;
      clock-menu-position-offset = 0;
      controls-manager-spacing-size = 0;
      dash = false;
      dash-icon-size = 0;
      double-super-to-appgrid = true;
      gesture = true;
      hot-corner = false;
      keyboard-layout = true;
      looking-glass-height = 0;
      looking-glass-width = 0;
      notification-banner-position = 5;
      osd = true;
      osd-position = 6;
      panel = true;
      panel-arrow = true;
      panel-corner-size = 0;
      panel-in-overview = true;
      panel-notification-icon = true;
      power-icon = true;
      quick-settings = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 0;
      switcher-popup-delay = true;
      theme = false;
      top-panel-position = 0;
      type-to-search = true;
      window-demands-attention-focus = false;
      window-picker-icon = true;
      window-preview-caption = true;
      window-preview-close-button = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-peek = true;
      workspace-popup = true;
      workspace-switcher-should-show = false;
      workspace-wrap-around = false;
      workspaces-in-app-grid = true;
      world-clock = false;
    };

    "org/gnome/shell/extensions/mediacontrols" = {
      cache-images = true;
      colored-player-icon = false;
      element-order = [ "icon" "title" "controls" "menu" ];
      extension-index = 0;
      extension-position = "center";
      hide-media-notification = false;
      max-widget-width = 350;
      mouse-actions = [ "toggle_play" "toggle_menu" "toggle_info" "previous" "next" "none" "none" "none" ];
      prefer-using-seek = false;
      seperator-chars = [ "|" "|" ];
      show-control-icons = false;
      show-next-icon = false;
      show-player-icon = false;
      show-playpause-icon = true;
      show-prev-icon = false;
      show-seek-back = false;
      show-seek-forward = false;
      show-seperators = false;
      show-sources-menu = false;
      show-text = true;
      track-label = [ "track" "-" "artist" ];
    };

    "org/gnome/shell/extensions/next-up" = {
      which-panel = 2;
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-unsafe-quick-toggle-enabled = false;
      input-always-show = true;
      input-show-selected = false;
      media-control-enabled = true;
      notifications-enabled = true;
      notifications-integrated = true;
      notifications-position = "bottom";
      notifications-use-native-controls = false;
      output-show-selected = false;
      user-removed-buttons = [ "NightLightToggle" "KeyboardBrightnessToggle" "DarkModeToggle" "BackgroundAppsToggle" "SystemItem" "BrightnessItem"];
      volume-mixer-position = "top";
      volume-mixer-show-description = true;
      volume-mixer-show-icon = true;
    };


    "org/gnome/shell/extensions/rounded-window-corners" = {
      border-width = 0;
      custom-rounded-corner-settings = "@a{sv} {}";
      focused-shadow = "{'vertical_offset': 4, 'horizontal_offset': 0, 'blur_offset': 28, 'spread_radius': 4, 'opacity': 60}";
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <false>, 'fullscreen': <false>}>, 'border_radius': <uint32 10>, 'smoothing': <0.10000000000000001>, 'enabled': <true>}";
      settings-version = mkUint32 5;
      skip-libadwaita-app = true;
      skip-libhandy-app = false;
      tweak-kitty-terminal = false;
      unfocused-shadow = "{'horizontal_offset': 0, 'vertical_offset': 2, 'blur_offset': 12, 'spread_radius': -1, 'opacity': 65}";
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      active-workspace-border-radius = 50;
      active-workspace-border-width = 0;
      active-workspace-font-weight = "700";
      active-workspace-padding-h = 7;
      active-workspace-padding-v = 3;
      empty-workspace-border-radius = 50;
      empty-workspace-border-width = 0;
      empty-workspace-font-weight = "700";
      empty-workspace-padding-h = 7;
      empty-workspace-padding-v = 3;
      inactive-workspace-border-radius = 50;
      inactive-workspace-border-width = 0;
      inactive-workspace-font-weight = "700";
      inactive-workspace-padding-h = 7;
      inactive-workspace-padding-v = 3;
      workspace-margin = 0;
      workspaces-bar-padding = 8;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = false;
      indicator-style = "workspaces-bar";
      position-index = 0;
      scroll-wheel = "workspaces-bar";
      show-empty-workspaces = false;
      smart-workspace-names = true;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-activate-workspace-shortcuts = false;
      enable-move-to-workspace-shortcuts = false;
    };

    "org/gnome/shell/extensions/space-bar/state" = {
      workspace-names-map = ''
        {}
      '';
    };

    "org/gnome/shell/extensions/task-widget" = {
      disabled-task-lists = [];
      group-past-tasks = true;
      hide-completed-tasks = 2;
      hide-empty-completed-task-lists = true;
      hide-header-for-singular-task-lists = false;
      last-active = "f417ed5763f4cc9664c083cb053e36678d60f4de";
      merge-task-lists = false;
      show-only-selected-categories = false;
      task-list-order = [ "system-task-list" "fc599df9afaea2c477524fdd890e713f2d782353" ];
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
      restore-window = [ "<Super>Down" ];
      search-popup-layout = [];
      show-layout-panel-indicator = false;
      single-screen-gap = 10;
      tile-bottom-half = [ "<Super>KP_2" ];
      tile-bottom-half-ignore-ta = [];
      tile-bottomleft-quarter = [ "<Super>KP_1" ];
      tile-bottomleft-quarter-ignore-ta = [];
      tile-bottomright-quarter = [ "<Super>KP_3" ];
      tile-bottomright-quarter-ignore-ta = [];
      tile-edit-mode = [];
      tile-left-half = [ "<Super>Left" "<Super>KP_4" ];
      tile-left-half-ignore-ta = [];
      tile-maximize = [ "<Super>Up" "<Super>KP_5" ];
      tile-maximize-horizontally = [];
      tile-maximize-vertically = [];
      tile-right-half = [ "<Super>Right" "<Super>KP_6" ];
      tile-right-half-ignore-ta = [];
      tile-top-half = [ "<Super>KP_8" ];
      tile-top-half-ignore-ta = [];
      tile-topleft-quarter = [ "<Super>KP_7" ];
      tile-topleft-quarter-ignore-ta = [];
      tile-topright-quarter = [ "<Super>KP_9" ];
      tile-topright-quarter-ignore-ta = [];
      toggle-always-on-top = [];
      toggle-tiling-popup = [];
      window-gap = 10;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
      toggle-application-view = [ "" ];
      toggle-overview = [ "" ];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

  };
}
