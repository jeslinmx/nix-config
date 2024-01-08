{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-23-05.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-23-11.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs = inputs:
  let mkNixos = configs: builtins.mapAttrs (
    hostname: {
      system ? "x86_64-linux",
      nixpkgs-version ? "nixpkgs-23-11",
      nixpkgs-config ? {},
    }:
      let
        nixpkgsConfig = { inherit system; config = nixpkgs-config; };
        specialArgs = with inputs; {
          inherit self;
          pkgs = import inputs.${nixpkgs-version} nixpkgsConfig;
          unstable = import nixpkgs-unstable nixpkgsConfig;
          lanzaboote = lanzaboote.nixosModules.lanzaboote;
          home-manager = home-manager.nixosModules.home-manager;
        };
      in inputs.${nixpkgs-version}.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          { networking.hostName = hostname; }
          ./nixos/default.nix
          ./nixos/${hostname}/configuration.nix
          ./nixos/${hostname}/hardware-configuration.nix
        ];
      }
  ) configs;
  in {
    nixosConfigurations = mkNixos {
      jeshua-nixos = { system = "x86_64-linux"; nixpkgs-config.allowUnfree = true; };
      jeshua-speqtral = { system = "x86_64-linux"; nixpkgs-config.allowUnfree = true; };
    };
  };
}
