{...}: {
  lib,
  pkgs,
  ...
}: {
  # For secure boot to work, you must do the following steps:
  # 0. reboot into UEFI menu and set Secure Boot to Setup Mode
  # 1. create signing keys using `nix run nixpkgs#sbctl create-keys`
  # 1a. alternatively, import them using `nix run nixpkgs#sbctl import-keys -- --directory ...`
  # 2. enroll keys using `nix run nixpkgs#sbctl -- enroll-keys --append --microsoft --ignore-immutable`
  # 3. set Secure Boot back to Deployed Mode if not automatically reverted

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote.enable = true;
    lanzaboote.pkiBundle = "/etc/secureboot/";
    # for TPM auto-unlocking
    # note that when the boot environment changes (e.g. UEFI firmware update, new secure boot keys enrolled),
    # the PCRs will be invalidated, and thus the TPM will stop dispensing the previously enrolled key
    # the following command must be run to regenerate a new key and wipe the old one:
    # systemd-cryptenroll <device name> --tpm2-device=auto --tpm2-pcrs=0,2,7 --wipe-slot=tpm2
    initrd.systemd = {
      enable = true;
      tpm2.enable = true;
    };
  };
  environment.systemPackages = [pkgs.sbctl];
}
