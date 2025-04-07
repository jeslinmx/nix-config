{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid";
      package = pkgs.colloid-icon-theme;
    };
  };
  fonts.fontconfig = {
    enable = true;
    defaultFonts = let
      inherit (config.stylix.fonts) sansSerif serif monospace;
    in {
      sansSerif = [sansSerif.name];
      serif = [serif.name];
      monospace = [monospace.name "Symbols Nerd Font Mono"];
      emoji = ["Blobmoji"];
    };
  };
}
