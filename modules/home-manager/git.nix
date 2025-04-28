{...}: {
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    userName = "Jeshua Lin";
    userEmail = "jeslinmx@users.noreply.github.com";
    difftastic = {
      enable = true;
      display = "side-by-side";
      background = "dark";
    };
    aliases = {
      a = "add";
      adog = "log --all --decorate --oneline --graph";
      b = "branch";
      c = "commit -m";
      ca = "commit -am";
      cl = "clone";
      co = "checkout";
      d = "diff";
      f = "fetch";
      l = "log --ext-diff";
      m = "merge";
      r = "restore";
      ra = "remote add";
      s = "status";
      sh = "show --ext-diff";
      st = "stash";
      sw = "switch";
      unstage = "restore --staged";
    };
    extraConfig = {
      color.ui = "auto";
      init.defaultBranch = "main";
      diff = {
        mnemonicPrefix = true;
        renames = true;
        submodule = "log";
      };
      grep = {
        break = true;
        heading = true;
        lineNumber = true;
        extendedRegexp = true;
      };
      pull.ff = "only";
      status = {
        submoduleSummary = true;
        showUntrackedFiles = "all";
      };
      tag.sort = "version:refname";
      url = {
        "https://github.com/".insteadOf = "gh://";
        "https://gist.github.com/".insteadOf = "gist://";
        "git@github.com:".insteadOf = "gh:";
      };
      core = {
        autocrlf = "input";
        excludesFile =
          lib.pipe [
            # neovim
            "Session.vim"
            # macos
            ".DS_Store"
            ".Spotlight-V100"
            ".fseventsd"
            # windows
            "Thumbs.db"
            "Desktop.ini"
            # linux
            ".Trash-*"
            ".direnv"
            "**.swp"
            "**.swo"
          ] [
            (builtins.concatStringsSep "\n")
            (pkgs.writeText ".gitignore")
            (builtins.getAttr "outPath")
          ];
      };
    };
  };
}
