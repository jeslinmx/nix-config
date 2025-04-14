{...}: {
  services.openssh = {
    enable = true;

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
  security.pam.rssh.enable = true;
}
