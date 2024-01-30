{ inputs, outputs, ... }:
let sourcedModules = with builtins; with outputs.lib; with outputs.dirUtils;
  mapAttrs (_: modtype:
    mapAttrs' (fname: path:
      nameValuePair (strings.removeSuffix ".nix" fname) path
    ) (readDirFiles modtype)
  ) (readSubdirs ./.);
in sourcedModules // {
  lanzaboote = inputs.lanzaboote.nixosModules.lanzaboote;
  home-manager = inputs.home-manager.nixosModules.home-manager;
}
