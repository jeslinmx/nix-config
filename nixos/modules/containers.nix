{ lib, pkgs, config, ... }: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = true; # docker command alias
      dockerSocket.enable = true; # docker api socket
      defaultNetwork.settings.dns_enabled = true; # inter-container networking
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
  hardware.nvidia-container-toolkit.enable = lib.mkDefault (builtins.elem "nvidia" config.services.xserver.videoDrivers);
  environment.systemPackages= [ pkgs.podman-compose ];
}
