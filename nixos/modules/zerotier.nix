{ flake, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = flake.inputs.private-config.zerotier-networks;
  };
}
