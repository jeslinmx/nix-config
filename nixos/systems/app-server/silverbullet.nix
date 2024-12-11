{ config, ... }: {
  services.silverbullet = {
    enable = true;
  };
  services.caddy.proxiedServices."sb.zt.jesl.in" = "${config.services.silverbullet.listenAddress}:${builtins.toString config.services.silverbullet.listenPort}";
}
