{
  security.pam.services.sudo.rssh = true;
  security.sudo.extraConfig = ''
    # disable prompt timeout
    Defaults passwd_timeout=0
  '';
}
