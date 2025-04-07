{pkgs, ...}: {
  home = {
    sessionVariables = {
      PAGER = "less -R";
    };
    shellAliases = {
    };
  };
  programs.fish = {
    shellAbbrs = {
      g = "git";
      v = "nvim";
      vi = "nvim";
      f = "fuck";
      S = "sudo -v; sudo -E";
      s = "kitty +kitten ssh";
      t = "tmux new-session -A -s 0";
      "/" = "grep";
      lg = "lazygit";
      cm = "chezmoi";
      dc = "docker compose";
    };
    functions = {
      l = "for arg in $argv; test -d $arg; and ll $arg; or less $arg; end";
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi --cwd-file="$tmp" $argv
        if set cwd (cat -- "$tmp") && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
      fzfkjv = ''
        fzf --query "$argv" \
          --disabled --no-sort --multi --no-header --no-keep-right --layout=reverse-list --prompt "kjv " \
          --bind "start:reload(kjv {q}),change:reload(kjv {q})" \
          --preview "awk -F '  ' '{print \$2}' {+f}" --preview-window "down,wrap"
      '';
      fzftar = ''
        tar -tf "$argv" \
        | grep -e '[^/]$' \
        | fzf --multi --prompt=' ' --print0 \
          --preview="tar -xf \"$argv\" --to-stdout {} | bat --file-name \"{}\" --color=always --style=numbers,rule,snip" \
        | xargs --null --no-run-if-empty tar -xOf $argv
      '';
      multicd = "echo (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history = "echo $history[1]";
    };
    interactiveShellInit = ''
      if [ $SHLVL -eq 1 ]
          function fish_greeting
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
  home.packages = [pkgs.kjv];
}
