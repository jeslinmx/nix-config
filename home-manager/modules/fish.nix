{
  home = {
    sessionVariables = let
      ctrlTPreviewer = "bat --color=always --style=changes,header-filesize,numbers,rule,snip {}";
      altCPreviewer = "eza --color=always --git --icons --group-directories-first -l --tree --level=1 {}";
      basicHeader = "ctrl-space: toggle preview window; ctrl-p/n: previous/next command";
      fdHeader = "ctrl-g: include .gitignore; ctrl-h: include dotfiles; ${basicHeader}";
      basicBinds = "ctrl-space:toggle-preview,ctrl-p:prev-history,ctrl-n:next-history";
      fdBinds = cmd: "ctrl-g:reload(${cmd} --no-ignore),ctrl-h:reload(${cmd} --hidden)";
    in rec {
      EDITOR = "vim";
      PAGER = "less -R";
      FZF_DEFAULT_COMMAND = "fd -c always";
      FZF_CTRL_T_COMMAND = "${FZF_DEFAULT_COMMAND} -t file";
      FZF_ALT_C_COMMAND  = "${FZF_DEFAULT_COMMAND} -t directory";
      FZF_DEFAULT_OPTS = "--ansi --track --keep-right --info=inline-right --marker=◆ --ellipsis=… --bind='${basicBinds}' --header='${basicHeader}' --prompt='fzf '";
      FZF_CTRL_R_OPTS = "${FZF_DEFAULT_OPTS} --prompt=' ' --border=rounded";
      FZF_CTRL_T_OPTS = "${FZF_DEFAULT_OPTS} --prompt=' ' --preview-window=border-sharp --preview='${ctrlTPreviewer}' --header='${fdHeader}' --bind='${fdBinds FZF_CTRL_T_COMMAND}'";
      FZF_ALT_C_OPTS  = "${FZF_DEFAULT_OPTS} --prompt=' ' --preview-window=border-double --preview='${altCPreviewer}' --header='${fdHeader}' --bind='${fdBinds FZF_ALT_C_COMMAND}'";
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
      lg = "lazygit";
      cm = "chezmoi";
      dc = "docker compose";
      nr = "nix run nixpkgs#";
      ns = "nix shell nixpkgs#";
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
