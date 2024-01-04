{
    boot.initrd.systemd.enable = true; # experimentally use systemd in stage 1, required for early plymouth
    boot.plymouth.enable = true;
}
