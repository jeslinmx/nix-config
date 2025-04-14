{...}: {
  lib,
  pkgs,
  ...
}: {
  # BRIGHTNESS CONTROL
  environment.systemPackages = [pkgs.ddcutil];
  hardware.i2c.enable = true; # for ddcutil

  # AUDIO
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true; # optional recommendation for pipewire
  # PulseAudio must be disabled for Pipewire
  hardware.pulseaudio.enable = lib.mkForce false;

  # PRINTING AND SCANNING
  services.ipp-usb.enable = true; # enable (driverless) scanning and printing; also enables CUPS and SANE automatically
  services.avahi = {
    nssmdns4 = true; # resolve .local addresses
    nssmdns6 = true;
  };

  # TPM
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
  };

  hardware.bluetooth.enable = true;

  services.fwupd.enable = true;
}
