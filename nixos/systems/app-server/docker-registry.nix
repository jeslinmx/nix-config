{ config, ... }: {
  services.dockerRegistry = {
    enable = true;
    enableDelete = true;
    enableGarbageCollect = true;
  };
  services.caddy.proxiedServices."dr.zt.jesl.in" = "${config.services.dockerRegistry.listenAddress}:${builtins.toString config.services.dockerRegistry.port}";
}
