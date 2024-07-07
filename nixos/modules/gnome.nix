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
    dconf-editor
    eog
    gnome-calculator
    gnome-calendar
    gnome-connections
    gnome-extension-manager
    gnome-font-viewer
    nautilus
    simple-scan
    unoconv # allows sushi to open Office files without crashing
  ;}) ++ (builtins.attrValues { inherit (pkgs.gnome)
    gnome-characters
    gnome-contacts
    gnome-software
    gnome-weather
  ;});
}
