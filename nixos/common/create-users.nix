{ config, lib, self, pkgs, unstable, home-manager, ... }:
with lib;
{
  imports = [ home-manager ];

  options.createUsers = mkOption {
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
    extraSpecialArgs = { inherit pkgs; inherit unstable; };
    users = builtins.mapAttrs (
      username: { ... }: import ( self.outPath + "/home-manager/${username}" )
    ) config.createUsers;
  };
}
