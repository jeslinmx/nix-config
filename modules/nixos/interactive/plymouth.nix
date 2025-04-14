{...}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true; # experimentally use systemd in stage 1, required for early plymouth
    kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail"];
    plymouth.enable = true;
  };
}
