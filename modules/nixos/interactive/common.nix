{lib, ...}: {
  imports = [
    ../base/common.nix
    ./chinese-input.nix
    ./console.nix
    ./enable-standard-hardware.nix
    ./enable-via-qmk.nix
    ./greetd.nix
    ./hyprland.nix
    ./ios-usb.nix
    ./plymouth.nix
    ./stylix.nix
    ./windows-fonts.nix
  ];
  config = lib.mkOverride 900 {
    services.flatpak.enable = true;
  };
}
