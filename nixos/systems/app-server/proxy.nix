{ flake, config, lib, pkgs, ...}: let
  pkgs-patched = import flake.inputs.nixpkgs-caddy-plugins { inherit (pkgs.caddy) system; };
in {
  options.services.caddy.proxiedServices = lib.mkOption {
    type = lib.types.attrsOf (lib.types.separatedString " ");
    default = [];
  };
  config = {
    services.caddy = {
      enable = true;
      package = pkgs-patched.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = "sha256-Aqu2st8blQr/Ekia2KrH1AP/2BVZIN4jOJpdLc1Rr4g=";
      };
      # for testing
      # acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      email = "jeslinmx@gmail.com";
      enableReload = false; # since admin API is disabled
      globalConfig = ''
        admin off
        grace_period 10s
        acme_dns cloudflare {env.CF_API_TOKEN}
        servers {
          metrics
        }
      '';
      virtualHosts = lib.mapAttrs (name: address: { extraConfig = ''
        reverse_proxy ${address} {
          header_up Host {upstream_hostport}
        }
        encode zstd gzip
      ''; }) config.services.caddy.proxiedServices;
    };
    # trigger caddy restart on re-config
    systemd.services.caddy.restartTriggers = [ config.services.caddy.configFile ];
    # get cloudflare api token from age
    systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.cf_token.path;
    age.secrets.cf_token.file = ./cf_token.age;
    # open firewall
    networking.firewall.interfaces = lib.mapAttrs' (nwid: ifrname:
      lib.nameValuePair ifrname { allowedTCPPorts = [ 80 443 ]; }
    ) config.zerotier.network-interfaces;
    # increase socket buffer size for quic-go
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };
  };
}