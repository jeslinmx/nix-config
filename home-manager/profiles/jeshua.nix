{homeModules, privateHomeModules, pkgs, ...}: {
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

  home.packages = with pkgs; [
    powershell
    wimlib
  ];
}
