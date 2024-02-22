{
  description = "~/ sweet ~/.";

  inputs = {
    home-manager-unstable.url = "github:nix-community/home-manager";
    "home-manager-23.11".url = "github:nix-community/home-manager/release-23.11";
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
  };

  outputs = {nixpkgs, ...} @ inputs: rec {
    homeModules = with builtins; with nixpkgs.lib; let
      dir = ./modules;
      dirContents = readDir dir;
      moduleFiles = filterAttrs (fname: type: (type == "regular") && (strings.hasSuffix ".nix" fname)) dirContents;
    in
      mapAttrs' (
        fname: _:
          attrsets.nameValuePair
          (strings.removeSuffix ".nix" fname)

          (import /${dir}/${fname})
      )
      moduleFiles;

    homeConfigurations = with builtins; with nixpkgs.lib; let
      dir = ./profiles;
      dirContents = readDir dir;
      profileFiles = filterAttrs (fname: type: (type == "regular") && (strings.hasSuffix ".nix" fname)) dirContents;
    in
      mapAttrs' (
        fname: _: let username = (strings.removeSuffix ".nix" fname);
          in attrsets.nameValuePair
          username
          ({ osConfig ? {}, ... }: {
            imports = [ /${dir}/${fname} ];
            home = {
              stateVersion = mkDefault (osConfig.system.stateVersion or "23.11");
              username = mkDefault username;
              homeDirectory = mkDefault "/home/${username}";
            };
          })
      )
      profileFiles;

    setup-module = branchName: users: { config, ... }: {
      imports = [inputs."home-manager-${branchName}".nixosModules.home-manager];
      config = with nixpkgs.lib; mkMerge
      ( [ { home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs;
          inherit homeModules;
          privateHomeModules = inputs.private-config.homeModules;
        };
      }; users.mutableUsers = true; } ] ++ (mapAttrsToList (
        username: cfg: {
          users.users.${username} = {
            initialHashedPassword = mkDefault "";
            isNormalUser = mkDefault true;
            group = mkIf config.users.users.${username}.isNormalUser (mkOverride 900 username);
          } // cfg;
          users.groups.${username} = mkIf config.users.users.${username}.isNormalUser {};
          home-manager.users.${username} = homeConfigurations.${username};
        }
        ) users) );
    };
  };
}
