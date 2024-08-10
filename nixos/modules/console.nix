{ flake, config, pkgs, ... }: let
  pkgs-patched = import flake.inputs.nixpkgs-patched { inherit (config.nixpkgs.hostPlatform) system; };
in {
  console = {
    earlySetup = true;
    packages = [ pkgs-patched.cozette ];
    font = "${pkgs-patched.cozette}/share/consolefonts/cozette.psf";
  };
}
