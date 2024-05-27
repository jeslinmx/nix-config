{pkgs, ...}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = [ "nixpkgs=flake" ];
  environment.systemPackages = [pkgs.git]; # required for flakes
}
