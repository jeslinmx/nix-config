{ flake, pkgs, ... }: let
  pkgs-patched = import flake.inputs.nixpkgs-patched { inherit (pkgs.cozette) system; };
in {
  console = {
    earlySetup = true;
    packages = [ pkgs-patched.cozette ];
    font = "${pkgs-patched.cozette}/share/consolefonts/cozette6x13.psfu";
  };
}
