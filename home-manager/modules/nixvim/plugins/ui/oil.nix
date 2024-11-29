{
  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      columns = [ "size" "mtime" "icon" ];
      buf_options = {
        buflisted = true;
      };
    };
  };
}
