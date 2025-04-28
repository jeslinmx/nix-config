{nixosModules, ...}: {config, ...}: {
  imports = [nixosModules.server-restic-helper];
  backups.restic = {
    repositories = {
      onedrive = {
        repository = "rclone:onedrive:/file_data";
        rcloneConfigFile = config.sops.secrets."restic/rclone-onedrive-config".path;
      };
    };
    common = {
      passwordFile = config.sops.secrets."restic/password".path;
      timerConfig = {
        OnCalendar = "04:00";
        RandomizedDelaySec = "1h";
        Persistent = true; # immediately attempt if lapsed
      };
      pruneOpts = ["--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" "--keep-yearly 100"];
      checkOpts = ["--read-data"];
    };
    obfuscateServiceNames = true;
  };

  sops.secrets = {
    "restic/password" = {};
    "restic/rclone-onedrive-config" = {};
  };
}
