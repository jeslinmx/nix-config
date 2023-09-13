{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, lanzaboote, ... }:
  let system = "x86_64-linux";
    nixpkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = import nixpkgs nixpkgsConfig;
    unstable = import nixpkgs-unstable nixpkgsConfig;
    configureNixos = hostname:
    let specialArgs = { inherit hostname; inherit unstable; };
    in {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
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
      };
    };
  in {
    nixosConfigurations = configureNixos "jeshua-nixos";
  };
}
