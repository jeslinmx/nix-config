{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai = {}; # more text objects
      operators = {}; # ReplaceWithRegister (and others)
    };
  };
}
