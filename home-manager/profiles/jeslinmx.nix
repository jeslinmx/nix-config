{homeModules, private-config, pkgs, ...}: {
  imports = (builtins.attrValues { inherit (homeModules)
    aesthetics
    cli-programs
    gui-programs
    gnome-shell
    termshark
  ;}) ++ [private-config.homeModules.ssh-personal-hosts];

  xdg.enable = true;

  services = {
    syncthing.enable = true;
    flatpak.packages = [
      "md.obsidian.Obsidian"
      "de.haeckerfelix.Fragments"
      "org.godotengine.Godot"
      "net.lutris.Lutris"
      "com.valvesoftware.Steam"
      "io.itch.itch"
      "org.prismlauncher.PrismLauncher"
      "dev.vencord.Vesktop"
    ];
  };

  home.packages = (builtins.attrValues { inherit (pkgs)
    ### CLI TOOLS ###
    kjv

    ### GRAPHICAL ###
  ;}) ++ [
    ( pkgs.ollama.override { acceleration = "cuda"; } )
  ];
}
