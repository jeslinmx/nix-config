{...}: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
  };
  networking.networkmanager.enable = true;
  services.logind = {
    powerKey = "hibernate";
    lidSwitchDocked = "suspend";
  };
}
