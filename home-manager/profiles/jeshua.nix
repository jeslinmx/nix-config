{homeModules, privateHomeModules, ...}: {
  imports = with homeModules; [
    aesthetics
    common-programs
    gnome-shell
    rclone
    privateHomeModules.awscli
    privateHomeModules.ssh-config
  ];

  xdg.enable = true;

  programs = {
    vscode.enable = true; # natively handles config sync
  };
}
