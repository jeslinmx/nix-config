{nixosModules, ...}: {lib, ...}: {
  imports = builtins.attrValues {
    inherit
      (nixosModules)
      base-common
      interactive-chinese-input
      interactive-console
      interactive-enable-standard-hardware
      interactive-enable-via-qmk
      interactive-greetd
      interactive-hyprland
      interactive-ios-usb
      interactive-plymouth
      interactive-stylix
      interactive-windows-fonts
      ;
  };
  config = lib.mkOverride 900 {
    services.flatpak.enable = true;
  };
}
