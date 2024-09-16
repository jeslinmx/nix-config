{
  services.openssh = {
    enable = true;

    ports = [ 7222 ];

    authorizedKeysInHomedir = false;
    startWhenNeeded = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # breaks remote nixos-rebuild somehow
      # UsePAM = false;
      X11Forwarding = false;
    };
    extraConfig = ''
      AuthenticationMethods publickey
      PermitEmptyPasswords no
    '';
  };
}
