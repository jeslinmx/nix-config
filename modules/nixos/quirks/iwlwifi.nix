# https://bugzilla.kernel.org/show_bug.cgi?id=201319#c55
{...}: {
  boot.extraModprobeConfig = ''
    install iwlwifi echo 1 > /sys/bus/pci/devices/0000\:00\:14.3/reset; /run/current-system/sw/bin/modprobe --ignore-install iwlwifi
  '';
  systemd.services.load-iwlwifi = {
    serviceConfig.Type = "oneshot";
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    script = ''
      /run/current-system/sw/bin/modprobe iwlwifi
    '';
  };
}
