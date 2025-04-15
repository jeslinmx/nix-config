{inputs, ...}: {config, ...}: {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideFolders = false;
    settings = {
      devices =
        builtins.mapAttrs (name: id: {
          inherit id;
          autoAcceptFolders = true;
        })
        inputs.private-config.syncthing-devices;
      options = {
        urAccepted = -1;
      };
    };
  };
  services.caddy.proxiedServices."st.zt.jesl.in" = config.services.syncthing.guiAddress;
}
