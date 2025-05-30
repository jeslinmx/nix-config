{inputs, ...}: {
  lib,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    plugins = {
      inherit
        (pkgs.yaziPlugins)
        chmod
        diff
        full-border
        git
        mime-ext
        mount
        piper
        smart-enter
        smart-filter
        toggle-pane
        ouch
        ;
    };
    settings = {
      mgr = {
        sort_by = "natural";
        sort_sensitive = true;
        sort_dir_first = true;
        linemode = "mtime";
        show_symlink = true;
        scrolloff = 20;
      };
      preview = {
        image_delay = 50;
        max-height = 1000;
        max-width = 1000;
      };
      plugin = {
        prepend_fetchers = [
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
          {
            id = "mime";
            name = "*";
            run = "mime-ext";
            prio = "high";
          }
        ];
        append_previewers =
          lib.pipe {
            "*.json" = ''piper -- ${lib.getExe pkgs.gojq} "$1"'';
            "*.tar*" = ''piper --format=url -- ${lib.getExe pkgs.ouch} list "$1"'';
            "*.zip" = ''piper --format=url -- ${lib.getExe pkgs.ouch} list "$1"'';
            "*.7z" = ''piper --format=url -- ${lib.getExe pkgs.ouch} list "$1"'';
            "*.rar" = ''piper --format=url -- ${lib.getExe pkgs.ouch} list "$1"'';
            "*.md" = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w "$1"'';
            "*.csv" = ''piper -- ${lib.getExe' pkgs.rich-cli "rich"} "$1"'';
            "*.rst" = ''piper -- ${lib.getExe' pkgs.rich-cli "rich"} "$1"'';
            "*.ipynb" = ''piper -- ${lib.getExe' pkgs.rich-cli "rich"} "$1"'';
            "*" = ''piper -- ${lib.getExe pkgs.bat} --force-colorization --style=changes,numbers "$1"'';
          } [
            lib.attrsToList
            (builtins.map ({
              name,
              value,
            }: {
              inherit name;
              run = value;
            }))
          ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = ["g" "m"];
            run = "plugin chmod";
            desc = "Chmod selected files";
          }
          {
            on = ["g" "d"];
            run = "plugin diff";
            desc = "Diff selected file with hovered file";
          }
          {
            on = ["g" "M"];
            run = "plugin mount";
            desc = "Open mount manager";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<Enter>";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<Right>";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Filter smartly";
          }
          {
            on = ["g" "p"];
            run = "plugin toggle-pane min-parent";
            desc = "Minimize parent-directory pane";
          }
          {
            on = ["g" "P"];
            run = "plugin toggle-pane max-parent";
            desc = "Maximize parent-directory pane";
          }
          {
            on = ["g" "c"];
            run = "plugin toggle-pane min-current";
            desc = "Minimize current-directory pane";
          }
          {
            on = ["g" "C"];
            run = "plugin toggle-pane max-current";
            desc = "Maximize current-directory pane";
          }
          {
            on = ["g" "t"];
            run = "plugin toggle-pane min-preview";
            desc = "Minimize preview pane";
          }
          {
            on = ["g" "T"];
            run = "plugin toggle-pane max-preview";
            desc = "Maximize preview pane";
          }
        ];
        append_keymap = [
          {
            on = ["C" "z"];
            run = "plugin ouch zip";
            desc = "Compress into .zip";
          }
          {
            on = ["C" "t"];
            run = "plugin ouch tar";
            desc = "Compress into .tar";
          }
          {
            on = ["C" "g"];
            run = "plugin ouch tar.gz";
            desc = "Compress into .tar.gz";
          }
          {
            on = ["C" "7"];
            run = "plugin ouch 7z";
            desc = "Compress into .7z";
          }
          {
            on = ["C" "x"];
            run = "plugin ouch tar.xz";
            desc = "Compress into .tar.xz";
          }
          {
            on = ["C" "b"];
            run = "plugin ouch tar.bz2";
            desc = "Compress into .bz2";
          }
          {
            on = ["C" "l"];
            run = "plugin ouch tar.lz4";
            desc = "Compress into .lz4";
          }
        ];
      };
    };
    initLua = ''
      require("full-border"):setup { type = ui.Border.ROUNDED }
      require("smart-enter"):setup { open_multi = true, }
      require("git"):setup()
      th.git = th.git or {}
      th.git.untracked = ui.Style():fg("white")
      th.git.ignored = ui.Style():fg("gray")
      th.git.added = ui.Style():fg("green")
      th.git.modified = ui.Style():fg("yellow")
      th.git.deleted = ui.Style():fg("red")
      th.git.updated = ui.Style():fg("blue")
    '';
  };
}
