{
  inputs,
  homeModules,
  ...
}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit (homeModules) firefox kitty;
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
    mangohud = {
      enable = true;
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
      };
    };
    packages = [
      "org.keepassxc.KeePassXC"
      "org.telegram.desktop"
      "net.ankiweb.Anki"
      "com.rafaelmardojai.Blanket"
      "org.pipewire.Helvum"
    ];
  };

  # unnixed stuff
  home.packages =
    builtins.attrValues {
      inherit
        (pkgs)
        wl-clipboard
        # virt-manager
        clapper
        loupe
        zathura
        ;
    }
    ++ [
      pkgs.pavucontrol
      (pkgs.pantheon.switchboard-with-plugs.override {
        plugs = builtins.attrValues {
          inherit
            (pkgs.pantheon)
            switchboard-plug-about
            # broken due to missing org.gnome.settings-daemon.plugins.media-keys schema
            # switchboard-plug-sound
            switchboard-plug-network
            switchboard-plug-printers
            # pulls in wingpanel indicator and thus all of gnome
            # switchboard-plug-bluetooth
            switchboard-plug-applications
            ;
        };
        useDefaultPlugs = false;
      })
    ];
}
