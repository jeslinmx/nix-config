{ pkgs, ... }:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  services.printing.enable = true;
  services.xserver.libinput.enable = true;
  services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    };
}
