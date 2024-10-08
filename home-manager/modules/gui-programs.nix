{
  flake,
  pkgs,
  ...
}: let
  pkgs-unstable = import flake.inputs.nixpkgs-unstable { inherit (pkgs) system config; };
in {
  imports = builtins.attrValues {
    inherit (flake.homeModules) firefox kitty;
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
    kitty.package = pkgs-unstable.kitty;
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
  ;};
}
