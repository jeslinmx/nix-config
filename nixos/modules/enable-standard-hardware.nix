{lib, pkgs, ...}: {
  # AUDIO
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true; # optional recommendation for pipewire
  # ALSA and PulseAudio must be disabled for Pipewire
  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;

  # PRINTING AND SCANNING
  services.ipp-usb.enable = true; # enable (driverless) scanning and printing; also enables CUPS and SANE automatically

  services.fwupd.enable = true;
}
