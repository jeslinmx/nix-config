{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab
    cheese
    epiphany
    totem
    yelp
    geary
    seahorse
    gnome-maps
    gnome-music
    gnome-terminal
    pkgs.gedit
    pkgs.gnome-console
    pkgs.gnome-text-editor
    pkgs.gnome-photos
  ];

  networking.networkmanager.enable = true;
}
