{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [flake.inputs.agenix.nixosModules.default];

  services.coredns = {
    enable = true;
    config =
      ''
        (defaults) {
          any
          cancel
          errors
          loop
          minimal
          ready
          prometheus
        }
        (forward) {
          forward . tls://94.140.15.16 tls://94.140.14.15 tls://2a10:50c0::bad1:ff tls://2a10:50c0::bad2:ff {
            tls_servername family.adguard-dns.com
          }
        }
        . {
          health
          cache
          import defaults
          import forward
        }
      ''
      + builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (nwid: {config, ...}: ''
          ${config.dns.domain} {
            hosts /run/zt-hosts/${nwid} {
              fallthrough
            }
            import defaults
            import forward
          }
        '')
        flake.inputs.private-config.zerotier-networks));
  };

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  # the resolved stub resolver conflicts with coredns over port 53
  services.resolved = lib.mkIf config.services.resolved.enable {extraConfig = "DNSStubListener=no";};

  systemd = {
    services = {
      coredns = {
        wants = builtins.map (nwid: "zerotier-hosts@${nwid}.timer") (builtins.attrNames flake.inputs.private-config.zerotier-networks) ++ ["zerotierone.service"];
        after = builtins.map (nwid: "zerotier-hosts@${nwid}.service") (builtins.attrNames flake.inputs.private-config.zerotier-networks) ++ ["zerotierone.service"];
      };

      "zerotier-hosts@" = {
        description = "Create hosts mapping for members of ZeroTier network %i";
        environment = {
          ZT_API_ENDPOINT = "https://my.zerotier.com/api";
          ZT_NETWORK_ID = "%i";
        };
        serviceConfig = {
          EnvironmentFile = config.age.secrets.zt_token.path;
          RuntimeDirectory = "zt-hosts";
          RuntimeDirectoryPreserve = "yes";
        };
        path = [pkgs.jq pkgs.curl];
        script = ''
          curl -H "Authorization: bearer $ZT_TOKEN" -s $ZT_API_ENDPOINT/network/$ZT_NETWORK_ID/member | \
          ZT_HOSTNAME=$(curl -H "Authorization: bearer $ZT_TOKEN" -s $ZT_API_ENDPOINT/network/$ZT_NETWORK_ID | jq -r .config.dns.domain) \
          GENERATE_RFC4193=$(curl -H "Authorization: bearer $ZT_TOKEN" -s $ZT_API_ENDPOINT/network/$ZT_NETWORK_ID | jq -r .config.v6AssignMode.rfc4193) \
          GENERATE_6PLANE=$(curl -H "Authorization: bearer $ZT_TOKEN" -s $ZT_API_ENDPOINT/network/$ZT_NETWORK_ID | jq -r '.config.v6AssignMode.["6plane"]') \
          jq -r --from-file ${pkgs.fetchurl {
            url = "https://gist.githubusercontent.com/jeslinmx/d7c2e5a534e09634beb20b5991f431f1/raw/72329458062f02f80db4733d7719f1672cd76753/zerotier-hosts.jq";
            hash = "sha256-QkyOUIpxumeWfWjJRdckAo7QUKfUwLT4tlexVdKQiR8=";
          }} > /run/zt-hosts/$1
        '';
        scriptArgs = "%i";
        after = ["network.target"];
      };
    };
    timers."zerotier-hosts@".timerConfig.OnCalendar = "*-*-* *:*:00/15";
  };

  age.secrets.zt_token.file = ./zt_token.age;
}
