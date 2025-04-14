{...}: {pkgs, ...}: {
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      libimobiledevice
      ifuse
      idevicerestore
      ;
  };
}
