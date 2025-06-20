{inputs, ...}: {config, ...}: {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideFolders = false;
    settings = {
      devices =
        builtins.mapAttrs (name: id: {
          inherit id;
          autoAcceptFolders = true;
        })
        inputs.private-config.lib.syncthing-devices;
      options = {
        urAccepted = -1;
      };
    };
  };
  services.caddy.proxiedServices."st.app.jesl.in" = config.services.syncthing.guiAddress;

  backups.restic.services.syncthing = {
    paths = [config.services.syncthing.dataDir];
    backupPrepareCommand = "systemctl stop syncthing.service";
    backupCleanupCommand = "systemctl start syncthing.service";
  };
}
