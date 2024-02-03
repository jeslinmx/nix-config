{
  description = "~/ sweet ~/.";

  inputs = {
    home-manager-unstable.url = "github:nix-community/home-manager";
    "home-manager-23.11".url = "github:nix-community/home-manager/release-23.11";
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

    homeConfigurations = {
      jeslinmx = {osConfig ? {}, ...}: {
        imports = with homeModules; [
          aesthetics
          programs
          gnome-shell
          kitty
        ];

        home = {
          stateVersion = osConfig.system.stateVersion or "23.11";
          username = "jeslinmx";
          homeDirectory = "/home/jeslinmx";
        };
        xdg.enable = true;
      };
    };

    setup-module = branchName: {
      imports = [inputs."home-manager-${branchName}".nixosModules.home-manager];
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs;
          inherit homeModules;
        };
        users = homeConfigurations;
      };
    };
  };
}
