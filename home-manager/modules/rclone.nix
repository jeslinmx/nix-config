{ pkgs, ... }: {
  home.packages = [ pkgs.rclone ];
  systemd.user.services = {
    "rclone-mount@" = {
      Unit = {
        Description = "Mount rclone remote %I";
        After = [ "network.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full \"%I:\" \"%h/Documents/%I\"";
        ExecStop = "fusermount -uz \"%h/Documents/%I\"";
        Restart = "on-failure";
        RestartSec = 15;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
