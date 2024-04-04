{ config, nix-colors, nixpkgs-patched, pkgs, ... }: let
  pkgs-patched = import nixpkgs-patched { inherit (config.nixpkgs.hostPlatform) system; };
in {
  console = {
    earlySetup = true;
    packages = [ pkgs-patched.cozette ];
    font = "${pkgs-patched.cozette}/share/fonts/misc/cozette.psf";
    colors = with nix-colors.colorSchemes.catppuccin-mocha.palette; [
      base03 base08 base0B base0A base0D base0E base0C base06
      base04 base08 base0B base0A base0D base0E base0C base07
    ];
  };
  services.kmscon = {
    enable = false;
    hwRender = true;
    fonts = [ {
      name = "CaskaydiaCove NF";
      package = pkgs.nerdfonts.override {fonts = ["CascadiaCode"]; };
    } ];
  };
}
