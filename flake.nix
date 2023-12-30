{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, lanzaboote, ... }:
  let mkNixos = configs: builtins.mapAttrs (
    hostname: { system ? "x86_64-linux", allowUnfree ? false }:
      let
        nixpkgsConfig = { inherit system; config = { inherit allowUnfree; }; };
        specialArgs = {
          pkgs = import nixpkgs nixpkgsConfig;
          unstable = import nixpkgs-unstable nixpkgsConfig;
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          { networking.hostName = hostname; }
          ./nixos/common/default.nix
          ./nixos/${hostname}/configuration.nix
          ./nixos/${hostname}/hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.jeslinmx = import ./home-manager;
          }
        ];
      }
  ) configs;
  in {
    nixosConfigurations = mkNixos {
      jeshua-nixos = { allowUnfree = true; system = "x86_64-linux"; };
    };
  };
}
