{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = let
    hyprshade = lib.getExe pkgs.hyprshade;
  in {
    "$toggleShaders" = "${hyprshade} ls | sed 's/^..//' | $menu -dmenu -p hyprshade | xargs ${hyprshade} toggle";
    "$disableShaders" = "${hyprshade} off";
  };
  home.file.".config/hypr/shaders".source = ./shaders;
}
