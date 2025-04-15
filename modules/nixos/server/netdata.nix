{...}: {pkgs, ...}: {
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override {withCloudUi = true;};
    enableAnalyticsReporting = false;
    config = {
      web = {
        "allow dashboard from" = "localhost";
        "allow management from" = "localhost";
        "allow netdata.conf" = "localhost";
        "default port" = 19999;
      };
    };
  };
  services.caddy.proxiedServices."nd.zt.jesl.in" = "localhost:19999";
}
