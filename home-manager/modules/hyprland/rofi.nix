{ config, lib, pkgs, ... }: {
  programs.rofi = let
    overrides = { rofi-unwrapped = pkgs.rofi-wayland-unwrapped; };
  in {
    enable = true;
    package = pkgs.rofi.override overrides;
    plugins = lib.map (plugin: plugin.override overrides) (
      lib.attrValues { inherit (pkgs) rofi-calc rofi-top rofi-pulse-select;
    }) ++ [ pkgs.rofi-emoji-wayland (pkgs.rofi-file-browser.override { rofi = overrides.rofi-unwrapped; }) ];
    extraConfig = {
      modes = [ "combi" "run" "ssh" "calc" "top" "file-browser-extended" ];
      combi-modes = [ "window" "drun" ];
      combi-hide-mode-prefix = true;
      terminal = lib.getExe config.programs.kitty.package;
      matching = "fuzzy";
      scroll-method = 1; # non-paginated
      cycle = false;
      sidebar-mode = true;
      show-icons = true;
      window-thumbnail = true;
      window-format = "{t} <i>{c}</i>";
      display-combi = "󱁴";
      display-run = "";
      display-ssh = "󰢹";
      display-calc = "󱖦";
      display-top = "";
      display-file-browser-extended = "󱀲";
      display-emoji = "󰞅";
      # calc
      calc-command = "wl-copy {result}";
      # file-browser-extended
      file-browser-config = (pkgs.writeTextFile {
          name = "file-browser-config";
          text = ''
            depth 0
            oc-search-path
            sort-by-depth
            disable-icons
            hide-hidden-symbol " "
            show-hidden-symbol "󰘓"
            toggle-hidden-key "kb-custom-19"
          '';
        }).outPath;
      # keybinds
      kb-custom-19 = "Control+h"; kb-remove-char-back = "BackSpace,Shift+BackSpace";
    };
  };
}