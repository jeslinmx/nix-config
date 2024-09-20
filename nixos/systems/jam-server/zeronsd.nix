{ flake, config, lib, pkgs, ... }: let inherit (flake.inputs) agenix nixpkgs-unstable private-config; in {
  imports = [
    agenix.nixosModules.default
    "${nixpkgs-unstable}/nixos/modules/services/networking/zeronsd.nix"
  ];

  services.zeronsd.servedNetworks = lib.mapAttrs (nwid: ifrname:
    {
      package = (import nixpkgs-unstable { inherit (pkgs) system config; }).zeronsd;
      settings = { token = config.age.secrets.zeronsd_token.path; }
        // private-config.zerotier-networks.${nwid}.zeronsd;
    }
  ) config.zerotier.network-interfaces;

  networking.firewall.interfaces = lib.mapAttrs' (nwid: ifrname:
    lib.nameValuePair ifrname {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    }
  ) config.zerotier.network-interfaces;

  age.secrets.zeronsd_token = {
    file = ./zeronsd_token.age;
    owner = "zeronsd";
    group = "zeronsd";
  };
}
