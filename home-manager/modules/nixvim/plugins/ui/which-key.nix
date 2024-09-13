{
  programs.nixvim.plugins.which-key = {
    enable = true;
    operators = {
      gh = "Hunks to apply";
      gH = "Hunks to reset";
    };
    triggersNoWait = [ "<leader>" ];
    window = {
      border = "single";
    };
  };
}
