{ pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
  };
  networking.networkmanager.enable = true;
  services.logind = {
    powerKey = "hibernate";
    lidSwitchDocked = "suspend";
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet ${builtins.concatStringsSep " " [
        "--issue" # display /etc/issue
        "--time" # display current time
        "--user-menu" # display menu of users
        "--asterisks" # show feedback when entering password
        "--window-padding=1" # add some padding to the border of the screen
        "--remember --remember-user-session" # remember last selected user and their selected session
      ]}";
    };
  };
}
