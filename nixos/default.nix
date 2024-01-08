{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git # required for flakes
  ];

  users.defaultUserShell = pkgs.bashInteractive;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  security.sudo.extraConfig = ''
    # disable prompt timeout
    Defaults passwd_timeout=0
  '';
}
