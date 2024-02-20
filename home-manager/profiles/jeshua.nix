{homeModules, ...}: {
  imports = with homeModules; [
    aesthetics
    common-programs
    gnome-shell
    rclone
  ];

  xdg.enable = true;

  programs = {
    vscode.enable = true; # natively handles config sync
  };
}
