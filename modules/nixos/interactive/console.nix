{inputs, ...}: {pkgs, ...}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {inherit (pkgs.cozette) system;};
in {
  console = {
    earlySetup = true;
    packages = [pkgs-unstable.cozette];
    font = "${pkgs-unstable.cozette}/share/consolefonts/cozette6x13.psfu";
  };
}
