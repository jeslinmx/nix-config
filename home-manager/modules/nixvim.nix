{ pkgs, ... }: {
  home.packages = [ pkgs.zig ];
  programs.nixvim = {
  };
}
