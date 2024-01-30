{
  description = "NixOS and home-manager configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    lanzaboote.url = "github:nix-community/lanzaboote";
    # private-config.url = "github:jeslinmx/nix-private-config";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    puts = {
      inherit inputs;
      inherit (self) outputs;
    };
  in
    {
      inherit (nixpkgs-unstable) lib;
      dirUtils = import ./dirUtils.nix;
      formatter = flake-utils.lib.eachDefaultSystem (system: nixpkgs-unstable.legacyPackages.${system}.alejandra);

      modules = (import ./modules) puts;
      homeConfigurations = (import ./home-manager) puts;
      nixosConfigurations = (import ./nixos) puts;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs-unstable.legacyPackages.${system}.alejandra;
    });
}
