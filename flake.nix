{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs
    nixpkgs.url = "nixpkgs/release-24.05";
    nixpkgs-unstable.url = "nixpkgs";
    nixpkgs-nixos-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/patch-1";

    # NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-nixos-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs = {
        devshell.follows = "devshell";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
  };

  outputs = {
    flake-parts,
    devshell,
    ...
  } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } ( { self, lib, ... }: {
    imports = [
      devshell.flakeModule
    ];

    flake = let
      findModulesRecursive = path: let
        allPaths = lib.mapAttrs' (name: type:
          lib.nameValuePair
            (lib.removeSuffix ".nix" name)
            (
              if type == "directory" then findModulesRecursive (lib.path.append path name)
              else lib.path.append path name
            )
        ) (builtins.readDir path);
        nixPaths = lib.filterAttrsRecursive (name: path:
          (lib.isAttrs path)
          || (lib.hasSuffix ".nix" (builtins.toString path))
        ) allPaths;
        nixPathsDefaultsCollapsed = lib.mapAttrsRecursiveCond
          (as: !(as ? "default"))
          (_: x: (if lib.isAttrs x then x.default else x))
          nixPaths;
      in nixPathsDefaultsCollapsed;
    in {
      inherit findModulesRecursive;
      homeModules = findModulesRecursive ./home-manager/modules;
      homeConfigurations = findModulesRecursive ./home-manager/profiles;
      nixosModules = findModulesRecursive ./nixos/modules;
      nixosConfigurations = lib.mapAttrsRecursive (_: x: (import x) self) (findModulesRecursive ./nixos/systems);
    };

    systems = [ "x86_64-linux" ];
    perSystem = { pkgs, ... }: {
      packages = {
        default = self.nixosConfigurations.jeshua-toolbelt.config.system.build.isoImage;
        jeshua-devbox = self.nixosConfigurations.jeshua-devbox.config.formats.proxmox-lxc;
      };
      formatter = pkgs.alejandra;
      devshells.default = {
        commands = [
          { package = pkgs.nurl; category = "dev"; }
          { package = pkgs.nh; category = "build"; }
          { package = pkgs.nix-tree; category = "debug"; }
          { package = pkgs.nix-melt; category = "debug"; }
        ];
        packages = [ pkgs.nixd ];
      };
    };
  });
}
