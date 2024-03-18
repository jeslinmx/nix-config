{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-2311.url = "nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
    nix-colors.url = "github:misterio77/nix-colors";
    home-configs = {
      url = "path:./home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager-unstable.follows = "home-manager-unstable";
        home-manager-2311.follows = "home-manager-2311";
        private-config.follows = "private-config";
        nix-colors.follows = "nix-colors";
      };
    };
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
        packages = [ just alejandra nix-output-monitor nix-tree ];
      };
    });
}
