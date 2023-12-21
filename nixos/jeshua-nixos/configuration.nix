{ pkgs, unstable, ... }: {
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
    ../common/quirks-iwlwifi.nix
    ../common/allow-via-keyboards.nix
    ../common/fingerprint-auth.nix
    ../common/input.nix
  ];

  ### HARDWARE QUIRKS ###
  boot.extraModprobeConfig = ''
    install iwlwifi echo 1 > /sys/bus/pci/devices/0000\:00\:14.3/reset; modprobe --ignore-install iwlwifi
  '';
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

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

  ### POWER MANAGEMENT ###
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "powersave";
       turbo = "auto";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };

  ### NETWORKING ###
  networking.networkmanager.enable = true;

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
  services.flatpak.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab cheese epiphany gedit totem yelp geary seahorse
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

  ### FONTS ###
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];
}

