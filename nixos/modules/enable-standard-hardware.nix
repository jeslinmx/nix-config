{pkgs, ...}: {
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl.enable = true;
    sane.enable = true;
    sane.extraBackends = [pkgs.sane-airscan]; # enable driverless scanning
  };
  services = {
    xserver.libinput.enable = true;
    printing.enable = true;
    ipp-usb.enable = true; # enable usb driverless scanning
    avahi = {
      # enable network autodiscovery, particularly driverless printing
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };
}
