{
  flake,
  lib,
  pkgs,
  ...
}: let
  pkgs-unstable = import flake.inputs.nixpkgs-unstable {inherit (pkgs) system config;};
in {
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    keymap = {
      manager = {
        prepend_keymap = [
          {
            on = ["g" "d"];
            run = "plugin diff";
            desc = "Diff selected file with hovered file";
          }
          {
            on = ["g" "m"];
            run = "plugin chmod";
            desc = "Chmod selected files";
          }
          {
            on = ["g" "t"];
            run = "plugin hide-preview";
            desc = "Toggle preview pane";
          }
          {
            on = ["g" "T"];
            run = "plugin max-preview";
            desc = "Toggle preview pane maximized";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Filter smartly";
          }
        ];
        append_keymap = [
          {
            on = ["g" "D"];
            run = ''shell '${lib.getExe pkgs.xdragon} --on-top --and-exit --all $@' --confirm '';
            desc = "Drag and drop";
          }
        ];
      };
    };
    settings = {
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
      preview = {
        max-height = 1000;
        max-width = 1000;
      };
    };
    plugins = let
      yazi-rs = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        hash = "sha256-Sd3sA64j2TwRuOcH14ouC4LD14sGGaxfyq9Ys4xivvM=";
      };
    in {
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "main";
        hash = "sha256-wESy7lFWan/jTYgtKGQ3lfK69SnDZ+kDx4K1NfY4xf4=";
      };
      chmod = builtins.path {path = "${yazi-rs}/chmod.yazi";};
      diff = builtins.path {path = "${yazi-rs}/diff.yazi";};
      full-border = builtins.path {path = "${yazi-rs}/full-border.yazi";};
      git = builtins.path {path = "${yazi-rs}/git.yazi";};
      hide-preview = builtins.path {path = "${yazi-rs}/hide-preview.yazi";};
      max-preview = builtins.path {path = "${yazi-rs}/max-preview.yazi";};
      smart-filter = builtins.path {path = "${yazi-rs}/smart-filter.yazi";};
    };
    initLua = ''
      -- require("starship"):setup()
      require("git"):setup()
      require("full-border"):setup { type = ui.Border.ROUNDED }
    '';
  };
}
