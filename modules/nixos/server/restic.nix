{...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  services.restic.backups = let
    resticCommonCfg = service-name: service-path: cfg:
      {
        repository = "rclone:onedrive:/file_data/${builtins.hashString "sha256" service-name}";
        paths = [(lib.getAttrFromPath [service-name service-path] config.services)];
        passwordFile = config.sops.secrets."rclone/password".path;
        rcloneConfigFile = config.sops.secrets."rclone/config".path;
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
    gitea = let
      giteaCfg = config.services.gitea;
      dumpDir = giteaCfg.dump.backupDir;
    in
      resticCommonCfg "gitea" "backupDir" {
        paths = [dumpDir];
        backupPrepareCommand = let
          sudo = lib.getExe pkgs.sudo;
          gitea = lib.getExe giteaCfg.package;
          inherit (giteaCfg) user customDir;
        in ''
          ${sudo} -u ${user} mkdir -p ${dumpDir}
          ${sudo} -u ${user} ${gitea} dump -c ${customDir}/conf/app.ini --type tar --file ${dumpDir}/gitea-dump.tar
        '';
        backupCleanupCommand = ''
          rm -rf ${dumpDir}
        '';
      };

    syncthing = resticCommonCfg "syncthing" "dataDir" {};
    couchdb = resticCommonCfg "couchdb" "databaseDir" {};
    docker-registry = resticCommonCfg "docker-registry" "" {paths = [config.services.dockerRegistry.storagePath];};
  };

  sops.secrets = {
    "rclone/password" = {};
    "rclone/config" = {};
  };
}
