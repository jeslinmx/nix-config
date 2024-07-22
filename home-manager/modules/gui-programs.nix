{
  homeModules,
  pkgs,
  ...
}: let
  in
{
  imports = builtins.attrValues {
    inherit (homeModules) firefox kitty;
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
  };

  services.flatpak = {
    update = {
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    packages = [
      "com.github.tchx84.Flatseal"
      "com.usebottles.bottles"
      "org.keepassxc.KeePassXC"
      "org.telegram.desktop"
      "net.ankiweb.Anki"
      "com.rafaelmardojai.Blanket"
      "org.pipewire.Helvum"
    ];
  };

  # unnixed stuff
  home.packages = builtins.attrValues { inherit (pkgs)
    wl-clipboard
    virt-manager
    beeper
  ;};
}
