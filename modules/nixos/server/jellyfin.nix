{...}: {config, ...}: {
  services = {
    jellyfin.enable = true;
    caddy.proxiedServices."jf.zt.jesl.in" = "127.0.0.1:8096";
  };
  networking.firewall = {
    allowedTCPPorts = [8096 8920]; # for locally discovered LAN
    allowedUDPPorts = [1900 7359];
  };
  backups.restic.services.jellyfin = {
    paths = [config.services.jellyfin.dataDir];
    backupPrepareCommand = "systemctl stop jellyfin.service";
    backupCleanupCommand = "systemctl start jellyfin.service";
  };
}
