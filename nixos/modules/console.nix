{ config, nix-colors, nixpkgs-patched, pkgs, ... }: let
  pkgs-patched = import nixpkgs-patched { inherit (config.nixpkgs.hostPlatform) system; };
in {
  console = {
    earlySetup = true;
    packages = [ pkgs-patched.cozette ];
    font = "${pkgs-patched.cozette}/share/fonts/misc/cozette.psf";
  };
}
