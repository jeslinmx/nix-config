let
  jeslinmx = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOt/JmiwxM1ob/1k+Jw9nyQkh3dB3IGRm34+9Zv97l58"
  ];
  app-server = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmKso0pvOLWk+vJ/5gBgyVC+G8FPy+J06MUKT7rUNZ root@apps" ];
in {
  "zt_token.age".publicKeys = jeslinmx ++ app-server;
  "cf_token.age".publicKeys = jeslinmx ++ app-server;
}
