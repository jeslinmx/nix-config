{...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  services.gitea = {
    enable = true;
    appName = "Gitea";
    settings = rec {
      server = {
        DOMAIN = "gt.app.jesl.in";
        ROOT_URL = "https://${server.DOMAIN}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3001;
        SSH_CREATE_AUTHORIZED_KEYS_FILE = false;
      };
      repository = {
        ACCESS_CONTROL_ALLOW_ORIGIN = server.ROOT_URL;
      };
      cors = {
        ALLOW_DOMAIN = server.ROOT_URL;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
    database = {
      type = "sqlite3";
      createDatabase = true;
    };
  };
  services.caddy.proxiedServices.${config.services.gitea.settings.server.ROOT_URL} = "${config.services.gitea.settings.server.HTTP_ADDR}:${builtins.toString config.services.gitea.settings.server.HTTP_PORT}";

  backups.restic.services.gitea = let
    giteaCfg = config.services.gitea;
    dumpDir = giteaCfg.dump.backupDir;
  in {
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
}
