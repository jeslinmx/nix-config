{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs
    nixpkgs.url = "nixpkgs";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/patch-1";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-2311.url = "nixpkgs/nixos-23.11";

    # NixOS modules
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs = {
      devshell.follows = "devshell";
      flake-parts.follows = "flake-parts";
      home-manager.follows = "home-manager-unstable";
      nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    stylix.inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager-unstable";
    };
    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;

    # Home Manager
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixos-unstable";
    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    home-manager-2311.inputs.nixpkgs.follows = "nixos-2311";
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
        lib.mapAttrs (fname: _: (import /${dir}/${fname}) (inputs // {inherit (self) nixosModules setup-hm;})) configFiles;

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

      setup-hm = branchName: users: { config, ... }:
      let hmReleases = with inputs; {
        "23.11" = home-manager-2311;
        "unstable" = home-manager-unstable;
      };
      in {
        imports = [hmReleases.${branchName}.nixosModules.home-manager];
        config = lib.mkMerge
        ( [ { home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {
            nixpkgs-unstable = inputs.nixpkgs;
            inherit (self) homeModules;
            privateHomeModules = inputs.private-config.homeModules;
          };
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
                # due to https://github.com/gmodena/nix-flatpak/issues/25
                inputs.nixvim.homeManagerModules.nixvim
              ] ++ (if matchHmUsername then [(lib.attrByPath [username] {} self.homeConfigurations)] else []);
              home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "23.11");
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
