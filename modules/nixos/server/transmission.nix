{...}: {
  config,
  pkgs,
  ...
}: {
  services = {
    transmission = {
      enable = true;
      webHome = pkgs.fetchFromGitHub {
        owner = "killemov";
        repo = "Shift";
        rev = "9512734c87bc8eb1db25d8685a7a567c7a3af99e";
        hash = "sha256-BUuc3cvW5Tr8lsuyh1OOSRFdNxhB4e0M7Ts2FW99lgI=";
      };
      settings = {
        download-dir = "/mnt/medialibrary";
        incomplete-dir = "/mnt/medialibrary/.incomplete";
        rpc-port = 9091;
      };
    };
    caddy.proxiedServices."bt.zt.jesl.in" = "localhost:${builtins.toString config.services.transmission.settings.rpc-port}";
  };
}
