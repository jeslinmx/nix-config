let
  jeshua = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOt/JmiwxM1ob/1k+Jw9nyQkh3dB3IGRm34+9Zv97l58"
  ];
  jam-server = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBKv+bE0PTp051489z7USQ/ZmxRBt5fRYh4lsFArOOk root@jam-server" ];
in {
  "zt_token.age".publicKeys = jeshua ++ jam-server;
}
