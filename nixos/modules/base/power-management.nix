{lib, ...}: {
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.auto-cpufreq.enable = lib.mkForce false;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "auto";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
