{...}: {
  lib,
  pkgs,
  ...
}: let
  next-wallpaper = pkgs.writeShellApplication {
    name = "next-wallpaper";
    runtimeInputs = [pkgs.swww];
    text = ''
      current_img=$(swww query | grep -oPm 1 "currently displaying: image: \K.*")

      next_img=$(
        find "''${1:-$HOME/.local/share/wallpapers/}" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.pnm' -o -iname '*.tga' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.webp' -o -iname '*.bmp' \) -print | {
          first_img=
          while read -r img; do
            first_img=''${first_img:-$img}
            [[ $(realpath "$img") == $(realpath "$current_img") ]] && break
          done
          read -r next_img && echo "$next_img" || echo "$first_img"
        }
      )

      swww img "$next_img"
    '';
  };
in {
  home.packages = [next-wallpaper];
  systemd.user = {
    services.next-wallpaper = {
      Unit.Description = "Change to next wallpaper";
      Service = {
        Type = "oneshot";
        Environment = [
          "SWWW_TRANSITION=any"
          "SWWW_TRANSITION_FPS=60"
        ];
        ExecStart = lib.getExe next-wallpaper;
      };
    };
    timers.next-wallpaper = {
      Unit = {
        Description = "Change next wallpaper every minute";
        After = "wayland-session@Hyprland.target";
      };
      Timer.OnCalendar = "*:*:00";
      Install.WantedBy = ["wayland-session@Hyprland.target"];
    };
  };
}
