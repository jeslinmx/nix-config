{ pkgs, ... }:
{
  services.fprintd = {
      enable = true;
      # tod.enable = true;
      # tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  security.pam.services.login.fprintAuth = false;
    # security.pam.services.login.auth = {
    #   fprintd = {
    #     control = "sufficient";
    #   }
    # }
}
