{
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    secureSocket = true;
    sensibleOnTop = true;
    extraConfig = ''
      # for kitty images
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
