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
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "x-scheme-handler/settings" = "io.elementary.settings.desktop";
        "inode/directory" = "yazi.desktop";
        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      };
    };
  };
}
