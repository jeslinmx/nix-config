{...}: {config, ...}: {
  services.silverbullet = {
    enable = true;
    listenPort = 3000;
  };
  services.caddy.proxiedServices."sb.zt.jesl.in" = "${config.services.silverbullet.listenAddress}:${builtins.toString config.services.silverbullet.listenPort}";
}
