{...}: {pkgs, ...}: {
  services.netdata = {
    enable = true;
    package = pkgs.netdataCloud;
    enableAnalyticsReporting = false;
    config = {
      web = {
        "allow connections from" = "localhost fcc5:ae24:cb*";
        "allow dashboard from" = "localhost";
        "allow management from" = "localhost";
        "allow netdata.conf" = "localhost";
        "default port" = 19999;
      };
    };
  };

  services.caddy.proxiedServices."nd.app.jesl.in" = "localhost:19999";
  networking.firewall.allowedTCPPorts = [19999]; # for streaming
}
