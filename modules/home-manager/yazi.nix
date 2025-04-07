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
            on = ["g" "s"];
            run = "plugin what-size";
            desc = "Calculate size of selection or current directory";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Filter smartly";
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
        ];
        append_keymap = [
          {
            on = ["g" "D"];
            run = ''shell '${lib.getExe pkgs.xdragon} --on-top --and-exit --all $@' --confirm '';
            desc = "Drag and drop";
          }
          {
            on = ["C" "z"];
            run = "plugin ouch --args=zip";
            desc = "Compress into .zip";
          }
          {
            on = ["C" "t"];
            run = "plugin ouch --args=tar";
            desc = "Compress into .tar";
          }
          {
            on = ["C" "g"];
            run = "plugin ouch --args=tar.gz";
            desc = "Compress into .tar.gz";
          }
          {
            on = ["C" "7"];
            run = "plugin ouch --args=7z";
            desc = "Compress into .7z";
          }
          {
            on = ["C" "x"];
            run = "plugin ouch --args=tar.xz";
            desc = "Compress into .tar.xz";
          }
          {
            on = ["C" "b"];
            run = "plugin ouch --args=tar.bz2";
            desc = "Compress into .bz2";
          }
          {
            on = ["C" "l"];
            run = "plugin ouch --args=tar.lz4";
            desc = "Compress into .lz4";
          }
        ];
      };
    };
    settings = {
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
        ];
        append_previewers = [
          {
            name = "*.csv";
            run = "rich-preview";
          }
          {
            name = "*.md";
            run = "rich-preview";
          }
          {
            name = "*.rst";
            run = "rich-preview";
          }
          {
            name = "*.ipynb";
            run = "rich-preview";
          }
          {
            name = "*.json";
            run = "rich-preview";
          }
          {
            name = "*.zip";
            run = "ouch";
          }
          {
            name = "*.7z";
            run = "ouch";
          }
          {
            name = "*.tar";
            run = "ouch";
          }
          {
            name = "*.tar.*";
            run = "ouch";
          }
          {
            name = "*.rar";
            run = "ouch";
          }
          {
            name = "*";
            run = "hexyl";
          }
        ];
      };
      preview = {
        max-height = 1000;
        max-width = 1000;
      };
    };
    plugins = let
      yazi-rs = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "02d18be03812415097e83c6a912924560e4cec6d";
        hash = "sha256-1FZ8wcf2VVp6ZWY27vm1dUU1KAL32WwoYbNA/8RUAog=";
      };
    in {
      chmod = builtins.path {path = "${yazi-rs}/chmod.yazi";};
      diff = builtins.path {path = "${yazi-rs}/diff.yazi";};
      full-border = builtins.path {path = "${yazi-rs}/full-border.yazi";};
      git = builtins.path {path = "${yazi-rs}/git.yazi";};
      hide-preview = builtins.path {path = "${yazi-rs}/hide-preview.yazi";};
      max-preview = builtins.path {path = "${yazi-rs}/max-preview.yazi";};
      smart-filter = builtins.path {path = "${yazi-rs}/smart-filter.yazi";};
      smart-enter = builtins.path {path = "${yazi-rs}/smart-enter.yazi";};
      hexyl = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "hexyl.yazi";
        rev = "main";
        hash = "sha256-nsnnL3GluKk/p1dQZTZ/RwQPlAmTBu9mQzHz1g7K0Ww=";
      };
      ouch = pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "main";
        hash = "sha256-zLAaJrcZGNWlG2HjsZtN4u8JZAN+GLl2RtP9qCt3T74=";
      };
      rich-preview = pkgs.fetchFromGitHub {
        owner = "AnirudhG07";
        repo = "rich-preview.yazi";
        rev = "main";
        hash = "sha256-TwL0gIcDhp0hMnC4dPqaVWIXhghy977DmZ+yPoF/N98=";
      };
      what-size = pkgs.fetchFromGitHub {
        owner = "pirafrank";
        repo = "what-size.yazi";
        rev = "main";
        hash = "sha256-SDObD22u2XYF2BYKsdw9ZM+yJLH9xYTwSFRWIwMCi08=";
      };
    };
    initLua = ''
      require("git"):setup()
      require("full-border"):setup { type = ui.Border.ROUNDED }
    '';
  };
  home.packages = [
    pkgs.hexyl
    pkgs.ouch
    pkgs.rich-cli
  ];
}
