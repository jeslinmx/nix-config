{ config, ... }: {
  services = {
    flood = {
      enable = true;
      port = 4000;
      extraArgs = [ "--noauth" "--rtsocket=${config.services.rtorrent.rpcSocket}" ];
    };
    rtorrent.enable = true;
    caddy.proxiedServices."bt.zt.jesl.in" = "${config.services.flood.host}:${builtins.toString config.services.flood.port}";
  };
  systemd.services.flood.serviceConfig = {
    User = config.services.rtorrent.user;
    Group = config.services.rtorrent.group;
  };
}
