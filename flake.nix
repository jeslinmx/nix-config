{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-2311.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-configs.url = "path:./home-manager";
    home-configs.inputs.nixpkgs.follows = "nixpkgs";
    # private-config.url = "github:jeslinmx/nix-private-config";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    home-configs,
    ...
  } @ inputs:
    rec {
      inherit (home-configs.outputs) homeModules homeConfigurations;
      nixosModules = with builtins; with nixpkgs.lib; let
        dir = ./nixos/modules;
        dirContents = readDir dir;
        moduleFiles = filterAttrs (fname: type: (type == "regular") && (strings.hasSuffix ".nix" fname)) dirContents;
      in
        mapAttrs' (
          fname: _:
            attrsets.nameValuePair
            (strings.removeSuffix ".nix" fname)
            (import /${dir}/${fname})
        )
        moduleFiles;
      nixosConfigurations = with builtins; with nixpkgs.lib; let
        dir = ./nixos/systems;
        dirContents = readDir dir;
        configFiles = filterAttrs (fname: type: type == "directory") dirContents;
      in
        mapAttrs (fname: _: (import /${dir}/${fname}) (inputs // {inherit nixosModules;})) configFiles;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
      devShells.default = with (import nixpkgs { inherit system; }); mkShell {
        packages = [ just alejandra nix-output-monitor ];
      };
    });
}
