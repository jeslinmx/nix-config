{
  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      columns = [ "permissions" "size" "mtime" "icon" ];
      buf_options = {
        buflisted = true;
      };
    };
  };
}
