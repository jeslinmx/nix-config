{
  description = "~/ sweet ~/.";

  inputs = {
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {nixpkgs, nixvim, ...} @ inputs: rec {
    homeModules = let
      inherit (nixpkgs) lib;
      dir = ./modules;
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
      inherit (nixpkgs) lib;
      dir = ./profiles;
      dirContents = builtins.readDir dir;
      profileFiles = lib.filterAttrs (fname: type: (type == "regular") && (lib.hasSuffix ".nix" fname)) dirContents;
    in
      lib.mapAttrs' (
        fname: _: let username = (lib.removeSuffix ".nix" fname);
          in lib.nameValuePair
          username
          ({
            imports = [ /${dir}/${fname} ];
            home = {
              username = lib.mkDefault username;
              homeDirectory = lib.mkDefault "/home/${username}";
            };
          })
      )
      profileFiles;

    setup-module = branchName: users: { config, ... }:
    let hmReleases = with inputs; {
      "23.11" = home-manager-2311;
      "unstable" = home-manager-unstable;
    };
    in {
      imports = [hmReleases.${branchName}.nixosModules.home-manager];
      config = let inherit (nixpkgs) lib; in lib.mkMerge
      ( [ { home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs;
          inherit homeModules;
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
              nixvim.homeManagerModules.nixvim
            ] ++ (if matchHmUsername then [(lib.attrByPath [username] {} homeConfigurations)] else []);
            home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "23.11");
          };
        }
      ) users) );
    };
  };
}
