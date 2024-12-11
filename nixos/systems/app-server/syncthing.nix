{ flake, config, ... }: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
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
  services.caddy.proxiedServices."st.zt.jesl.in" = config.services.syncthing.guiAddress;
}
