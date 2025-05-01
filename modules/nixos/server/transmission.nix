{...}: {
  config,
  pkgs,
  ...
}: {
  services = {
    transmission = {
      enable = true;
      webHome = pkgs.flood-for-transmission;
      settings = {
        download-dir = "/mnt/medialibrary";
        rpc-port = 9091;
      };
    };
    caddy.proxiedServices."bt.zt.jesl.in" = "localhost:${builtins.toString config.services.transmission.settings.rpc-port}";
  };
}
