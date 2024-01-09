{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    corefonts
    vistafonts
    vistafonts-chs
  ];
}
