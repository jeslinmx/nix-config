{
  programs.fish = {
    shellAbbrs = {
      g = "git";
      v = "vim";
      "/" = "grep";
      cm = "chezmoi";
      fetch = "neofetch --config ~/.config/neofetch/simple.conf";
      sudo = "sudo -v; sudo -E";
    };
    functions = {
      l = "for arg in $argv; test -d $arg; and ll $arg; or less $arg; end";
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
    '';
  };
}
