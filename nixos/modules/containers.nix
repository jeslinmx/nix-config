{ lib, config, ... }: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # docker command alias
      dockerSocket.enable = true; # docker api socket
      defaultNetwork.settings.dns_enabled = true; # inter-container networking
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    containers.cdi.dynamic.nvidia.enable = lib.mkDefault (builtins.elem "nvidia" config.services.xserver.videoDrivers);
  };
}
