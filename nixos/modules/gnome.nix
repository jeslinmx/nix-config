{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome = {
      core-utilities.enable = false;
      sushi.enable = true;
    };
  };
  programs.gnome-disks.enable = true;
  programs.file-roller.enable = true;
  environment.systemPackages = (builtins.attrValues { inherit (pkgs)
    gnome-connections
    unoconv # allows sushi to open Office files without crashing
  ; inherit (pkgs.gnome)
    dconf-editor
    eog
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-contacts
    gnome-font-viewer
    gnome-software
    gnome-weather
    nautilus
    simple-scan
  ;});
}
