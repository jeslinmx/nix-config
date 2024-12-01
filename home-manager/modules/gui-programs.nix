{
  flake,
  config,
  pkgs,
  ...
}: let
  pkgs-unstable = import flake.inputs.nixpkgs-unstable { inherit (pkgs) system config; };
in {
  imports = builtins.attrValues {
    inherit (flake.homeModules) firefox kitty teams;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = let
      inherit (config.stylix.fonts) sansSerif serif monospace;
    in {
      sansSerif = [ sansSerif.name ];
      serif = [ serif.name ];
      monospace = [ monospace.name "Symbols Nerd Font Mono" ];
      emoji = [ "Blobmoji" ];
    };
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
    kitty.package = pkgs-unstable.kitty;
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };

  services.flatpak = {
    update = {
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    overrides.global = {
      Context = {
        sockets = ["wayland" "session-bus"];
        filesystems = [
          "~/.icons:ro"
        ];
      };
      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };
    packages = [
      "org.keepassxc.KeePassXC"
      "org.telegram.desktop"
      "net.ankiweb.Anki"
      "com.rafaelmardojai.Blanket"
      "org.pipewire.Helvum"
      "com.github.rafostar.Clapper"
    ];
  };

  # unnixed stuff
  home.packages = builtins.attrValues { inherit (pkgs)
    wl-clipboard
    virt-manager
  ;} ++ [
    pkgs.pavucontrol
    (pkgs.pantheon.switchboard-with-plugs.override {
      plugs = builtins.attrValues { inherit (pkgs.pantheon)
        switchboard-plug-about
        # broken due to missing org.gnome.settings-daemon.plugins.media-keys schema
        # switchboard-plug-sound
        switchboard-plug-network
        switchboard-plug-printers
        # pulls in wingpanel indicator and thus all of gnome
        # switchboard-plug-bluetooth
        switchboard-plug-applications
      ; };
      useDefaultPlugs = false;
    })
  ];
}
