{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let system = "x86_64-linux";
    nixpkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = import nixpkgs nixpkgsConfig;
    unstable = import nixpkgs-unstable nixpkgsConfig;
    configureNixos = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./nixos/${hostname}/configuration.nix
        ./nixos/${hostname}/hardware-configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit unstable; };
          home-manager.users.jeslinmx = import ./home-manager;
        }
      ];
    };
  in {
    nixosConfigurations = {
      "jeshua-nixos" = configureNixos "jeshua-nixos";
    };
  };
}
