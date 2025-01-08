{config, ...}: {
  services.couchdb = {
    enable = true;
    port = 5984;
    adminPass = "temporary";
    extraConfig = ''
      [couchdb]
      single_node=true
    '';
  };
  services.caddy.proxiedServices."ls.zt.jesl.in" = "${config.services.couchdb.bindAddress}:${builtins.toString config.services.couchdb.port}";
}
