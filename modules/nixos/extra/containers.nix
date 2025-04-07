{
  lib,
  pkgs,
  config,
  ...
}: {
  virtualisation = rec {
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
    docker = {
      enable = lib.mkDefault false;
      enableOnBoot = true;
      liveRestore = true;
      autoPrune = podman.autoPrune;
    };
  };
  hardware.nvidia-container-toolkit.enable = lib.mkDefault (builtins.elem "nvidia" config.services.xserver.videoDrivers);
  environment.systemPackages = lib.mkIf config.virtualisation.podman.enable [pkgs.podman-compose];
}
