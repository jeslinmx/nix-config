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
    nixpkgs.url = "nixpkgs/release-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/cozette-psfu";
    nixpkgs-caddy-plugins.url = "nixpkgs/b8a14976023e53f6e08e51dc61585838eb1f2828";

    # nix-darwin modules
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
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
    private-config = {
      url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Supporting repos
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    arcwtf = {
      url = "github:kikaraage/arcwtf/v1.3-firefox";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    devshell,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = [
        devshell.flakeModule
      ];

      flake = let
        inherit (self.lib) gatherModules;
      in {
        darwinModules = gatherModules ./modules/darwin;
        nixosModules = gatherModules ./modules/nixos;
        homeModules = gatherModules ./modules/home-manager;

        darwinConfigurations = builtins.mapAttrs (_: v:
          inputs.nix-darwin.lib.darwinSystem {modules = [((import v) self)];}) {
          jeshua-macbook = ./systems/jeshua-macbook;
        };
        nixosConfigurations = builtins.mapAttrs (_: v:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [((import v) self)];
          }) {
          app-server = ./systems/app-server;
          docker-devbox = ./systems/docker-devbox;
          jeshua-toolbelt = ./systems/jeshua-toolbelt;
          jeshua-xps-9510 = ./systems/jeshua-xps-9510;
          speqtral-devbox = ./systems/speqtral-devbox;
        };

        lib = {
          dirToAttrs = path:
            lib.pipe path [
              builtins.readDir
              (builtins.mapAttrs (
                name: type: let
                  fullPath = /${path}/${name};
                in
                  if type == "directory"
                  then self.lib.dirToAttrs fullPath
                  else fullPath
              ))
            ];
          filterNonNix = lib.filterAttrsRecursive (_: v: !(builtins.isPath v) || lib.hasSuffix ".nix" "${v}");
          filterEmptySubdirs = lib.filterAttrsRecursive (_: v: builtins.isPath v || builtins.length (builtins.attrNames v) != 0);
          flattenAttrs = let
            recurse = sep: prefix:
              lib.foldlAttrs (
                acc: n: v: let
                  fullPath = builtins.concatStringsSep sep (prefix ++ [n]);
                in
                  acc
                  // (
                    if builtins.isPath v
                    then {${fullPath} = v;}
                    else recurse sep [fullPath] v
                  )
              ) {};
          in
            sep: recurse sep [];
          truncateSuffix = lib.mapAttrs' (n: v: lib.nameValuePair (lib.pipe n [(lib.removeSuffix ".nix") (lib.removeSuffix "-default")]) v);
          gatherModules = lib.flip lib.pipe [
            self.lib.dirToAttrs
            self.lib.filterNonNix
            self.lib.filterEmptySubdirs
            (self.lib.flattenAttrs "-")
            self.lib.truncateSuffix
            (builtins.mapAttrs (_: import))
            (builtins.mapAttrs (_: v: v self))
          ];
        };
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        devshells.default = {
          commands = [
            {
              name = "deploy-server";
              category = "build";
              help = "Rebuild and switch <app-server> config";
              command = ''
                nixos-rebuild switch --flake $PRJ_ROOT#''${1:-app-server} --target-host ''${1:-app-server} ''${@:2}
              '';
            }
            {
              name = "build-image";
              category = "build";
              help = "Build <jeshua-toolbelt> <install-iso> image for ${system}";
              command = ''
                ${inputs.nixos-generators.apps.${system}.nixos-generate.program} \
                  --flake $PRJ_ROOT#''${1:-jeshua-toolbelt} \
                  --format ''${2:-install-iso} \
                  --system ''${3:-${system}} \
                  --show-trace
              '';
            }
            {
              package = pkgs.nurl;
              category = "dev";
            }
            {
              package = pkgs.sops;
              category = "dev";
            }
            {
              package = pkgs.nh;
              category = "build";
            }
            {
              package = pkgs.nix-tree;
              category = "debug";
            }
            {
              package = pkgs.nix-melt;
              category = "debug";
            }
          ];
          packages = [pkgs.nixd];
        };
      };
    });
}
