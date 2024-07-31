{flake, pkgs, ...}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = builtins.attrValues (builtins.mapAttrs (name: path: "${name}=${path}") flake.inputs);
  environment.systemPackages = [pkgs.git]; # required for flakes
}
