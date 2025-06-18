{
  inputs,
  nixosModules,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit
        (nixosModules)
        base-common
        extra-zerotier
        server-proxy
        server-restic
        server-transmission
        server-gitea
        server-jellyfin
        server-syncthing
        server-netdata
        server-docker-registry
        server-zerotier-coredns
        ;
      inherit (inputs.nixos-generators.nixosModules) proxmox-lxc;
      inherit (inputs.sops-nix.nixosModules) sops;
    }
    ++ [
    ];

  system.stateVersion = "24.05";

  ### ENVIRONMENT CUSTOMIZATION ###
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keyFiles = [inputs.private-config.packages.${pkgs.system}.ssh-authorized-keys];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "netdata/jam-pve" = {};
    };
    templates.netdata_stream_conf = {
      inherit (config.services.netdata) group;
      mode = "0440";
      restartUnits = ["netdata.service"];
      content = let
        inherit (config.sops) placeholder;
        mkChildCfg = apiKey: ''
          [${apiKey}]
            type = api
            enabled = yes
            allow from = fcc5:ae24:cb*
        '';
      in
        builtins.concatStringsSep "\n" (
          [
            ''
              [stream]
                enabled = no
                enable compression = yes
            ''
          ]
          ++ (builtins.map mkChildCfg [placeholder."netdata/jam-pve"])
        );
    };
  };
  services.netdata.configDir = {
    "stream.conf" = config.sops.templates.netdata_stream_conf.path;
  };

  services.samba = {
    enable = true;
    settings = {
      medialibrary = {
        browseable = "yes";
        path = "/mnt/medialibrary";
      };
    };
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
