{ pkgs, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  imports = [
    ../common/locale-sg.nix
    ../common/enable-standard-hardware.nix
    ../common/user-jeslinmx.nix
    ../common/cloudflare-warp.nix
  ];

  ### BOOT ###
  boot.loader = {
    timeout = 0;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false; # replaced with lanzaboote
    systemd-boot.netbootxyz.enable = true;
  };
  boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/4931d933-81f1-45c3-87b5-6944e52703fd";
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/etc/secureboot/";
  # boot.initrd.systemd.enable = true; # experimentally use systemd in stage 1, required for early plymouth
  # boot.plymouth.enable = true;

  ### NETWORKING ###
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  ### GRAPHICAL ENVIRONMENT ###
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  ### OTHER ENVIRONMENT CUSTOMIZATION ###
  nixpkgs.config.allowUnfree = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab cheese epiphany gedit totem yelp evince geary seahorse
    gnome-maps gnome-music gnome-terminal
    pkgs.gnome-console pkgs.gnome-text-editor pkgs.gnome-photos
  ];

  security.sudo.extraConfig = ''
    # disable prompt timeout
    Defaults passwd_timeout=0

    # make messing up sudo more fun
    Defaults insults
  '';

  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };
}

