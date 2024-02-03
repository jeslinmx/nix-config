{lib, ...}: {
  # For secure boot to work, you must do the following steps:
  # 0. reboot into UEFI menu and set Secure Boot to Setup Mode
  # 1. create signing keys using `nix run nixpkgs#sbctl create-keys`
  # 1a. alternatively, import them using `nix run nixpkgs#sbctl import-keys -- --directory ...`
  # 2. enroll keys using `nix run nixpkgs#sbctl enroll-keys -- --append --microsoft --ignore-immutable`
  # 3. set Secure Boot back to Deployed Mode if not automatically reverted

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote.enable = true;
    lanzaboote.pkiBundle = "/etc/secureboot/";
  };
}
