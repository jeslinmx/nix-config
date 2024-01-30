{ inputs, outputs, ... }@puts:
builtins.mapAttrs (systemName: baseSpec:
  let
    defaultSpec = {
      system = "x86_64-linux";
      nixpkgs = inputs.nixpkgs-2311;
      extra-nixpkgs = {};
      nixpkgs-config = {};
      modules = [];
    };
    spec = outputs.lib.recursiveUpdate defaultSpec baseSpec;
    nixpkgs-config = { inherit (spec) system; config = spec.nixpkgs-config; };
    specialArgs = puts // {
      pkgs = import spec.nixpkgs nixpkgs-config;
      extra-nixpkgs = (builtins.mapAttrs
        (name: n: import n nixpkgs-config)
        spec.extra-nixpkgs
      );
    };
  in spec.nixpkgs.lib.nixosSystem {
    inherit (spec) system;
    inherit specialArgs;
    modules = [ {
      networking.hostName = systemName;
      nixpkgs = nixpkgs-config;
    } ]
    ++ (spec.nixpkgs.lib.attrValues (outputs.dirUtils.readDirFiles ./${systemName}))
    ++ spec.modules;
  }
)
{
  jeshua-nixos = {
    nixpkgs = inputs.nixpkgs-2311;
    extra-nixpkgs = { inherit (inputs) nixpkgs-unstable; };
    nixpkgs-config.allowUnfree = true;
  };
  jeshua-speqtral = {
    nixpkgs = inputs.nixpkgs-2311;
    extra-nixpkgs = { inherit (inputs) nixpkgs-unstable; };
    nixpkgs-config.allowUnfree = true;
  };
}
