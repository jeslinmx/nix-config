{
  programs.lazygit = {
    settings = {
      gui = {
        scrollPastBottom = false;
        showBottomLine = false;
        nerdFontsVersion = 3;
        border = "rounded";
        theme = {
          activeBorderColor = [ "blue" "bold" ];
          inactiveBorderColor = [ "black" ];
          searchingActiveBorderColor = [ "cyan" ];
          optionsTextColor = [ "magenta" ];
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
          cherryPickedCommitBgColor = [ "default" ];
          cherryPickedCommitFgColor = [ "yellow" "underline" ];
          unstagedChangesColor = [ "red" ];
          defaultFgColor = [ "default" ];
        };
      };
      git.log = {
        order = "date-order";
        showGraph = "always";
        showWholeGraph = true;
      };
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
    };
  };
}
