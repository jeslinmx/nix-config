{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git # required for flakes
  ];

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  security.sudo.extraConfig = ''
    # disable prompt timeout
    Defaults passwd_timeout=0
  '';
}
