{ pkgs, ... }:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  hardware.sane = {
    enable = true; # enable scanning
    extraBackends = [ pkgs.sane-airscan ]; # enable driverless scanning
  };
  services.printing.enable = true;
  services.ipp-usb.enable = true; # enable usb driverless scanning
  services.xserver.libinput.enable = true;
  services.avahi = { # enable network autodiscovery, particularly driverless printing
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
