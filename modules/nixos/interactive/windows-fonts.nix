{...}: {pkgs, ...}: {
  fonts.packages = builtins.attrValues {
    inherit
      (pkgs)
      corefonts
      vistafonts
      vistafonts-chs
      ;
  };
}
