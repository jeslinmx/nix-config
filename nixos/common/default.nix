{ pkgs, hostname, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ pkgs.git ];

  networking.hostName = hostname;
}
