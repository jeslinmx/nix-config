{ outputs, pkgs, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  imports = with outputs.modules.nixos; [
    chinese-input
    cloudflare-warp
    create-users
    enable-standard-hardware
    gnome
    ios-usb
    locale-sg
    nix-enable-flakes
    nix-gc
    # plymouth
    power-management
    quirks-iwlwifi
    secure-boot
    sudo-disable-timeout
    windows-fonts
  ];

  users = {
    defaultUserShell = pkgs.bashInteractive;
  };
  createUsers.jeslinmx = {
    description = "Jeshy";
    extraGroups = [ "wheel" "scanner" "lp" ];
  };

  ### BOOT CUSTOMIZATION ###
  boot.loader = {
    timeout = 0;
    efi.canTouchEfiVariables = true;
    systemd-boot.netbootxyz.enable = true;
  };

  ### ENVIRONMENT CUSTOMIZATION ###
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  environment.sessionVariables = { GDK_SCALE = "1.5"; };
}
