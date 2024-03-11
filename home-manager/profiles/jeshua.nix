{homeModules, privateHomeModules, pkgs, ...}: {
  imports = with homeModules; [
    aesthetics
    common-programs
    gnome-shell
    colors
    rclone
    privateHomeModules.awscli
    privateHomeModules.ssh-speqtral-hosts
  ];

  colors.scheme = "catppuccin-mocha";
  xdg.enable = true;

  programs = {
    vscode.enable = true; # natively handles config sync
  };

  home.packages = with pkgs; [
    powershell
    wimlib
    ciscoPacketTracer8
  ];
}
