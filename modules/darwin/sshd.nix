{...}: {
  environment.etc."ssh/sshd_config.d/10-nix-darwin.conf".text = ''
    AuthorizedKeysFile none
    PermitRootLogin no
    PasswordAuthentication no
    PermitEmptyPasswords no
    AuthenticationMethods publickey
    KbdInteractiveAuthentication no
    X11Forwarding no
  '';
}
