{...}: {pkgs, ...}: {
  home.packages = [pkgs.teams-for-linux];
  home.file.".config/teams-for-linux/config.json".text = builtins.toJSON {
    appIconType = "light";
    menubar = "hidden";
  };
}
