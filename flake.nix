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
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
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
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";

    # Supporting repos
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    yaru = {
      url = "github:ubuntu/yaru";
      flake = false;
    };
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
      findModulesFlatten = path: lib.concatMapAttrs (name: type:
        if type == "directory"
          then lib.mapAttrs' (subname: path:
            lib.nameValuePair (lib.concatStringsSep "-" [name subname]) path
          ) (findModulesRecursive (lib.path.append path name))
          else if lib.hasSuffix ".nix" name
            then { "${lib.removeSuffix ".nix" name}" = lib.path.append path name; }
            else {}
      ) (builtins.readDir path);
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
      nixosModules = findModulesFlatten ./nixos/modules;
      nixosConfigurations = lib.mapAttrs (_: x: let
        isKnownArch = {name, ...}: lib.elem name lib.systems.flakeExposed;
        notFound = throw "no default.nix or <arch>.nix found";
        file = if lib.isAttrs x
          then lib.findFirst isKnownArch (lib.nameValuePair notFound notFound) (lib.attrsToList x)
          else lib.nameValuePair "x86_64-linux" x;
      in inputs.nixpkgs.lib.nixosSystem {
        system = file.name;
        modules = [ file.value ];
        specialArgs = { flake = self; };
      }) (findModulesRecursive ./nixos/systems);
    };

    systems = [ "x86_64-linux" ];
    perSystem = { pkgs, system, ... }: {
      formatter = pkgs.alejandra;
      devshells.default = {
        commands = [
          {
            name = "deploy-server";
            category = "build";
            help = "Rebuild and switch <app-server> config";
            command = ''
              nixos-rebuild switch --flake $PRJ_ROOT#''\${1:-app-server} --target-host ''\${1:-app-server} ''\${@:2}
            '';
          }
          {
            name = "build-image";
            category = "build";
            help = "Build <jeshua-toolbelt> <install-iso> image for ${system}";
            command = ''
              ${inputs.nixos-generators.apps.${system}.nixos-generate.program} \
                --flake $PRJ_ROOT#''\${1:-jeshua-toolbelt} \
                --format ''\${2:-install-iso} \
                --system ''\${3:-${system}} \
                --show-trace
            '';
          }
          { package = pkgs.nurl; category = "dev"; }
          { package = pkgs.nh; category = "build"; }
          { package = pkgs.nix-tree; category = "debug"; }
          { package = pkgs.nix-melt; category = "debug"; }
          { package = inputs.agenix.packages.${system}.default; category = "dev"; }
        ];
        packages = [ pkgs.nixd ];
        env = [
          { name = "RULES"; eval = "$PRJ_ROOT/secrets.nix"; }
        ];
      };
    };
  });
}
