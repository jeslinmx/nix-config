{pkgs, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid";
      package = pkgs.colloid-icon-theme;
    };
  };
}
