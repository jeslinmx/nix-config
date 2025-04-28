{...}: {config, ...}: {
  services.dockerRegistry = {
    enable = true;
    port = 5000;
    enableDelete = true;
    enableGarbageCollect = true;
  };
  services.caddy.proxiedServices."dr.zt.jesl.in" = "${config.services.dockerRegistry.listenAddress}:${builtins.toString config.services.dockerRegistry.port}";

  backups.restic.services.dockerRegistry = {
    paths = [config.services.dockerRegistry.storagePath];
    backupPrepareCommand = "systemctl stop docker-registry.service";
    backupCleanupCommand = "systemctl start docker-registry.service";
  };
}
