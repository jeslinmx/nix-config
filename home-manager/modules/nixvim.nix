{ pkgs, ... }: {
  home.packages = with pkgs; [ zig ];
  programs.nixvim = {
  };
}
