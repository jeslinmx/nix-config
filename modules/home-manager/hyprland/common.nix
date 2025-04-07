{
  lib,
  config,
  pkgs,
  ...
}: rec {
  # utility functions
  abs = x:
    if x < 0
    then x * -1
    else x;
  sign = x:
    if x < 0
    then "-"
    else "+";
  fmt-adj = x: "${builtins.toString (abs x)}%${sign x}";
  rgb = color: let
    c = config.lib.stylix.colors;
  in "rgb(${c."${color}-rgb-r"}, ${c."${color}-rgb-g"}, ${c."${color}-rgb-b"})";
  # common commands
  mute-command = dev: "${pkgs.wireplumber}/bin/wpctl set-mute ${dev} toggle";
  volume-command = dev: amt: let
    yaru = pkgs.fetchgit {
      url = "https://github.com/ubuntu/yaru";
      rev = "c81d7d904a8f1903234bee0bace559362c48dc61";
      hash = "sha256-gz9UueyRzZ5QMkDJ3KUsxAO2o48BKbRD3RRymNhR3cM=";
      sparseCheckout = ["sounds/src/stereo"];
    };
  in "${pkgs.wireplumber}/bin/wpctl set-volume ${dev} ${fmt-adj amt} ${
    if amt > 0
    then "&& wpctl set-mute ${dev} 0"
    else ""
  } && pw-cat -p ${yaru.outPath}/sounds/src/stereo/audio-volume-change.oga";
  brightness-command = amt: "${lib.getExe pkgs.brightnessctl} set --min-value=960 --exponent=2 ${fmt-adj amt}";
  move-monitor-command = dir: ''hyprctl keyword monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.name), \(.width)x\(.height), auto-${dir}, \(.scale)"')"'';
  scrot-date-format = "+%Y-%m-%d %k-%M-%S.%N";
  scrot-base-command = "${lib.getExe pkgs.hyprshot} --output-folder ~/Pictures/Screenshots/ --filename \"Screenshot from $(date \"${scrot-date-format}\").png\" --freeze --current";
}
