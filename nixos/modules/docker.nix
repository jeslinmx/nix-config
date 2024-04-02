{ lib, config, ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    liveRestore = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    rootless.enable = true;
    enableNvidia = lib.mkDefault (builtins.elem "nvidia" config.services.xserver.videoDrivers);
  };
}
