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

    flake = {
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
        lib.mapAttrs (fname: _: (import /${dir}/${fname}) (inputs // {inherit (self) nixosModules mkHmUsers;})) configFiles;

      homeModules = let
        dir = ./home-manager/modules;
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

      homeConfigurations = let
        dir = ./home-manager/profiles;
        dirContents = builtins.readDir dir;
        profileFiles = lib.filterAttrs (fname: type: (type == "regular") && (lib.hasSuffix ".nix" fname)) dirContents;
      in
        lib.mapAttrs' (
          fname: _: let username = (lib.removeSuffix ".nix" fname);
            in lib.nameValuePair
            username
            {
              imports = [ /${dir}/${fname} ];
              home = {
                username = lib.mkDefault username;
                homeDirectory = lib.mkDefault "/home/${username}";
              };
            }
        )
        profileFiles;

      mkHmUsers = users: { config, ... }: {
        imports = [inputs.home-manager.nixosModules.home-manager];
        config = lib.mkMerge
        ( [ { home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = inputs // { inherit (self) homeModules; };
          backupFileExtension = "hmbak";
        }; users.mutableUsers = true; } ] ++ (lib.mapAttrsToList (
          username: { hmCfg ? {}, matchHmUsername ? true, ... } @ userCfg: {
            users.users.${username} = {
              initialHashedPassword = lib.mkDefault "";
              isNormalUser = lib.mkDefault true;
              group = lib.mkIf config.users.users.${username}.isNormalUser (lib.mkOverride 900 username);
            } // ( lib.filterAttrs (k: _: !(builtins.elem k ["hmCfg" "matchHmUsername"])) userCfg );
            users.groups.${username} = lib.mkIf config.users.users.${username}.isNormalUser {};
            home-manager.users.${username} = { osConfig, ... }: {
              imports = [
                hmCfg
                # due to https://github.com/nix-community/nixvim/issues/83
                inputs.nixvim.homeManagerModules.nixvim
                # due to https://github.com/gmodena/nix-flatpak/issues/25
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ] ++ (if matchHmUsername then [(lib.attrByPath [username] {} self.homeConfigurations)] else []);
              home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
            };
          }
        ) users) );
      };
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
