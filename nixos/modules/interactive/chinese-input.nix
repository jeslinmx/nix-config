{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = [pkgs.ibus-engines.rime];
  };

  fonts.packages = builtins.attrValues { inherit (pkgs)
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    source-han-mono
  ;};
}
