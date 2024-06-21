{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";

    # nixpkgs
    nixpkgs.url = "nixpkgs";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/patch-1";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-2311.url = "nixpkgs/nixos-23.11";

    # NixOS modules
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";
    stylix.url = "github:danth/stylix";
    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    home-configs.url = "path:./home-manager";
    home-configs.inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager-unstable.follows = "home-manager-unstable";
      home-manager-2311.follows = "home-manager-2311";
      private-config.follows = "private-config";
    };
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
  };

  outputs = {
    flake-parts,
    devshell,
    home-configs,
    ...
  } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } ( { self, lib, ... }: {
    imports = [
      devshell.flakeModule
    ];

    flake = {
      inherit (home-configs.outputs) homeModules homeConfigurations;
      nixosModules = let
        dir = ./nixos/modules;
        dirContents = builtins.readDir dir;
        moduleFiles = lib.filterAttrs (fname: type: (type == "regular") && (lib.hasSuffix ".nix" fname)) dirContents;
      in
      lib.mapAttrs' (
        fname: _:
        lib.nameValuePair
        (lib.removeSuffix ".nix" fname)
        (import /${dir}/${fname})
        )
        moduleFiles;
      nixosConfigurations = let
          dir = ./nixos/systems;
          dirContents = builtins.readDir dir;
          configFiles = lib.filterAttrs (fname: type: type == "directory") dirContents;
        in
        lib.mapAttrs (fname: _: (import /${dir}/${fname}) (inputs // {inherit (self) nixosModules;})) configFiles;
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
