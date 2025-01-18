{
  config,
  flake,
  lib,
  pkgs,
  ...
}: {
  imports = [flake.inputs.agenix.nixosModules.default];

  services.restic.backups = let
    resticCommonCfg = service-name: service-path: cfg:
      {
        repository = "rclone:onedrive:/file_data/${builtins.hashString "sha256" service-name}";
        paths = [(lib.getAttrFromPath [service-name service-path] config.services)];
        passwordFile = config.age.secrets.rclone_password.path;
        rcloneConfigFile = config.age.secrets.rcloneConfig.path;
        timerConfig = {
          OnCalendar = "04:00";
          RandomizedDelaySec = "1h";
          Persistent = true; # immediately attempt if lapsed
        };
        backupPrepareCommand = "systemctl stop ${service-name}.service";
        backupCleanupCommand = "systemctl start ${service-name}.service";
        pruneOpts = ["--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" "--keep-yearly 100"];
        checkOpts = ["--read-data"];
      }
      // cfg;
  in {
    syncthing = resticCommonCfg "syncthing" "dataDir" {};
    couchdb = resticCommonCfg "couchdb" "databaseDir" {};
    docker-registry = resticCommonCfg "docker-registry" "" {paths = [config.services.dockerRegistry.storagePath];};
  };

  age.secrets.rcloneConfig.file = ./rcloneConfig.age;
  age.secrets.rclone_password.file = ./rclone_password.age;
}
