{
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 7;
    settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} ${builtins.concatStringsSep " " [
      "--time --time-format '%Y/%m/%d (%a) %H:%M:%S'" # display current time
      "--user-menu" # display menu of users
      "--asterisks" # show feedback when entering password
      "--window-padding=2" # add some padding to the border of the screen
      "--remember --remember-user-session" # remember last selected user and their selected session
    ]}";
  };
}
