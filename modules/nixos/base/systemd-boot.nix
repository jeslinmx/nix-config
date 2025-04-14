{...}: {
  boot.loader.systemd-boot = {
    configurationLimit = 10;
    netbootxyz.enable = true;
    memtest86.enable = true;
  };
}
