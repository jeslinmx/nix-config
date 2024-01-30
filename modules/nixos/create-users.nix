{ inputs, outputs, lib, config, ... }:
{
  imports = [ outputs.modules.home-manager ];

  options.createUsers = with lib; mkOption {
    type = with types; attrsOf ( submodule {
      options = {
        description = mkOption { type = passwdEntry str; default = ""; };
        extraGroups = mkOption { type = listOf str; default = []; };
        linger = mkOption { type = bool; default = false; };
        shell = mkOption { type = nullOr (either shellPackage (passwdEntry path)); default = config.users.defaultUserShell; };
      };
    } );
    default = {};
  };

  config.users = {
    users = builtins.mapAttrs (
      username: userOptions: {
        isNormalUser = true;
        group = username;
      } // userOptions
    ) config.createUsers;
    groups = builtins.mapAttrs ( username: { ... }: {} ) config.createUsers;
  };

  config.home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs outputs; };
    users = builtins.mapAttrs (
      username: _: outputs.homeConfigurations.${username}
    ) config.createUsers;
  };
}
