{homeModules, privateHomeModules, pkgs, ...}: {
  imports = (builtins.attrValues { inherit (homeModules)
    aesthetics
    cli-programs
    gui-programs
    gnome-shell
  ;}) ++ [privateHomeModules.ssh-personal-hosts];

  xdg.enable = true;

  services = {
    syncthing.enable = true;
  };

  home.packages = (builtins.attrValues { inherit (pkgs)
    ### CLI TOOLS ###
    kjv

    ### GRAPHICAL ###
    prismlauncher
    godot_4
  ;}) ++ [
    ( pkgs.ollama.override { acceleration = "cuda"; } )
  ];
}
