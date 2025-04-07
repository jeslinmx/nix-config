{config, ...}: {
  programs.fzf = let
    basicHeader = "ctrl-space: toggle preview window; ctrl-p/n: previous/next command";
    fdHeader = "ctrl-g: include .gitignore; ctrl-h: include dotfiles; ${basicHeader}";
    basicBinds = "ctrl-space:toggle-preview,ctrl-p:prev-history,ctrl-n:next-history,up:track+up,down:track+down";
    fdBinds = cmd: "ctrl-g:reload(${cmd} --no-ignore),ctrl-h:reload(${cmd} --hidden)";
  in {
    defaultCommand = "fd";
    defaultOptions = [
      "--ansi"
      "--keep-right"
      "--info=inline-right"
      "--marker=◆"
      "--ellipsis=…"
      "--header='${basicHeader}'"
      "--prompt='fzf'"
      "--bind='${basicBinds}'"
    ];
    fileWidgetCommand = "${config.programs.fzf.defaultCommand} -t file";
    fileWidgetOptions =
      config.programs.fzf.defaultOptions
      ++ [
        "--header='${fdHeader}'"
        "--prompt=' '"
        "--preview-window=border-sharp"
        "--preview='bat --color=always --style=changes,header-filesize,numbers,rule,snip {}'"
        "--bind='${fdBinds config.programs.fzf.fileWidgetCommand}'"
      ];
    changeDirWidgetCommand = "${config.programs.fzf.defaultCommand} -t directory";
    changeDirWidgetOptions =
      config.programs.fzf.defaultOptions
      ++ [
        "--header='${fdHeader}'"
        "--prompt=' '"
        "--preview-window=border-double"
        "--preview='eza --color=always --git --icons --group-directories-first -l --tree --level=1 {}'"
        "--bind='${fdBinds config.programs.fzf.changeDirWidgetCommand}'"
      ];
    historyWidgetOptions = config.programs.fzf.defaultOptions ++ ["--prompt=' '" "--border=rounded"];
  };
}
