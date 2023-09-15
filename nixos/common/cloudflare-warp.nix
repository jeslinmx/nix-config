{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.cloudflare-warp ];
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.services.warp-svc = {
    after = [ "network-online.target" "systemd-resolved.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      StateDirectory = "cloudflare-warp";
      User = "warp";
      Umask = "0077";
      # Hardening
      LockPersonality = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      # Leaving on strict activates warp on plus
      ProtectSystem = "full";
      RestrictNamespaces = true;
      RestrictRealtime = true;
    };
    enable = false;
  };

  # security.pki.certificateFiles = [
  #   fetchurl {
  #     url = "https://developers.cloudflare.com/cloudflare-one/static/documentation/connections/Cloudflare_CA.pem";
  #     hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   }
  # ];
  networking.firewall.allowedUDPPorts = [ 2408 ];

  users.users.warp = {
    isSystemUser = true;
    group = "warp";
    description = "Cloudflare Warp user";
    home = "/var/lib/cloudflare-warp";
  };
  users.groups.warp = {};
}
