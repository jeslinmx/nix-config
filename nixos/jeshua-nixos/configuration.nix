{
  outputs,
  pkgs,
  ...
}: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  imports = with outputs.modules.nixos; [
    chinese-input
    cloudflare-warp
    create-users
    enable-standard-hardware
    enable-via-qmk
    gnome
    ios-usb
    locale-sg
    nix-enable-flakes
    nix-gc
    power-management
    quirks-iwlwifi
    secure-boot
    steam
    sudo-disable-timeout
    windows-fonts
  ];

  users = {
    defaultUserShell = pkgs.bashInteractive;
  };
  createUsers.jeslinmx = {
    description = "Jeshy";
    extraGroups = ["wheel" "scanner" "lp"];
  };

  ### BOOT CUSTOMIZATION ###
  boot.loader = {
    timeout = 0;
    efi.canTouchEfiVariables = true;
    systemd-boot.netbootxyz.enable = true;
  };
  boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/4931d933-81f1-45c3-87b5-6944e52703fd";

  ### ENVIRONMENT CUSTOMIZATION ###
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernel.sysctl = {"vm.swappiness" = 0;};
  environment.sessionVariables = {GDK_SCALE = "1.5";};
}
