{ lanzaboote, ... }: {
  imports = [ lanzaboote ];

  boot = {
    loader.systemd-boot.enable = false;
    lanzaboote.enable = true;
    lanzaboote.pkiBundle = "/etc/secureboot/";
  };
}
