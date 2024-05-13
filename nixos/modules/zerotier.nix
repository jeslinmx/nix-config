{ private-config, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = private-config.zerotier-networks;
  };
}
