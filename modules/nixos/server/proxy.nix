{...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.caddy.proxiedServices = lib.mkOption {
    type = lib.types.attrsOf (lib.types.separatedString " ");
    default = [];
  };
  config = {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
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
      virtualHosts =
        lib.mapAttrs (name: address: {
          extraConfig = ''
            reverse_proxy ${address} {
              header_up Host {upstream_hostport}
            }
            encode zstd gzip
          '';
        })
        config.services.caddy.proxiedServices;
    };
    # trigger caddy restart on re-config
    systemd.services.caddy.restartTriggers = [config.services.caddy.configFile];
    # get cloudflare api token from sops
    systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates.caddy-envFile.path;
    # open firewall
    networking.firewall.interfaces =
      lib.mapAttrs' (
        nwid: ifrname:
          lib.nameValuePair ifrname {allowedTCPPorts = [80 443];}
      )
      config.zerotier.network-interfaces;
    # increase socket buffer size for quic-go
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };

    sops = {
      secrets."caddy/cloudflare-api-token" = {};
      templates.caddy-envFile.content = "CF_API_TOKEN=${config.sops.placeholder."caddy/cloudflare-api-token"}";
    };
  };
}
