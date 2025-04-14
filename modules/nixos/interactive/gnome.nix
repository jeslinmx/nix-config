{...}: {pkgs, ...}: {
  networking.firewall.allowedTCPPorts = [3389 3390]; # for RDP
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome = {
      core-utilities.enable = false;
      sushi.enable = true;
      gnome-remote-desktop.enable = true;
    };
  };
  programs.gnome-disks.enable = true;
  programs.file-roller.enable = true;
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      gnome-connections
      ;
    inherit
      (pkgs.gnome)
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
      ;
  };
}
