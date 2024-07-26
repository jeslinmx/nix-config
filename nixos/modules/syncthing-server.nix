{ flake, ... }: {
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    overrideFolders = false;
    settings = {
      devices = builtins.mapAttrs (name: id: {
        inherit id;
        autoAcceptFolders = true;
      }) flake.inputs.private-config.syncthing-devices;
      options = {
        urAccepted = -1;
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 21027 22000 ];
  };
}
