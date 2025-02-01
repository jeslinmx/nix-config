{
  xdg = {
    enable = true; # manage XDG base directories
    userDirs = {
      enable = true; # manage XDG user directories
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "text/*" = "nvim.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "org.onlyoffice.desktopeditors.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "org.onlyoffice.desktopeditors.desktop";
        "inode/directory" = "yazi.desktop";
        "x-scheme-handler/settings" = "io.elementary.settings.desktop";
        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
        "video/*" = "clapper.desktop";
        "image/*" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
      };
    };
  };
}
