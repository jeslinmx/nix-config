{ config, lib, ... }: {
  services.silverbullet = {
    enable = true;
    listenAddress = "0.0.0.0";
    listenPort = 3000;
  };
  networking.firewall.interfaces = lib.mapAttrs' (nwid: ifrname:
    lib.nameValuePair ifrname { allowedTCPPorts = [ config.services.silverbullet.listenPort ]; }
  ) config.zerotier.network-interfaces;
}
