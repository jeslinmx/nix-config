{
  home = {
    sessionVariables = {
      EDITOR = "vim";
      PAGER = "less -R";
    };
    shellAliases = {
      fetch = "neofetch --config ~/.config/neofetch/simple.conf";
    };
  };
  programs.fish = {
    shellAbbrs = {
      g = "git";
      v = "vim";
      f = "fuck";
      S = "sudo -v; sudo -E";
      s = "kitty +kitten ssh";
      "/" = "grep";
      cm = "chezmoi";
      dc = "docker compose";
    };
    functions = {
      l = "for arg in $argv; test -d $arg; and ll $arg; or less $arg; end";
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi --cwd-file="$tmp"
        if set cwd (cat -- "$tmp") && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
      multicd = "echo (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history = "echo $history[1]";
    };
    interactiveShellInit = ''
      if [ $SHLVL -eq 1 ]
          function fish_greeting
              neofetch --config ~/.config/neofetch/simple.conf
          end
      else
          set fish_greeting ""
      end
      fish_add_path -p ~/.local/bin
      fish_vi_key_bindings
      set fish_cursor_visual block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore

      abbr -a .. --position anywhere -r '^\.\.+$' -f multicd
      abbr -a !! --position anywhere -f last_history
    '';
  };
}
