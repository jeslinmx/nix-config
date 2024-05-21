{homeModules, privateHomeModules, pkgs, ...}: {
  imports = with homeModules; [
    aesthetics
    cli-programs
    gui-programs
    gnome-shell
    privateHomeModules.ssh-personal-hosts
  ];

  xdg.enable = true;

  services = {
    syncthing.enable = true;
  };

  home.packages = with pkgs; [
      ### CLI TOOLS ###
      kjv
      ( ollama.override { acceleration = "cuda"; } )

      ### GRAPHICAL ###
      prismlauncher
      godot_4
  ];
}
