{inputs, ...}: {
  config,
  lib,
  ...
}: let
  inherit (inputs.private-config.lib) zerotier-networks;

  # Convert a string like "8056c2e21c36f91e" to the zerotier network interface name like "ztmjfpigyc"
  ifrname = let
    inherit (lib) bitAnd bitOr bitXor concatStrings elemAt findFirst foldl length range substring stringLength stringToCharacters toLower zipLists;
    hexChars = stringToCharacters "0123456789abcdef";
    base32Chars = stringToCharacters "abcdefghijklmnopqrstuvwxyz234567";
    # Return an integer between 0 and 15 representing the hex digit
    fromHexDigit = c:
      (findFirst (x: x.fst == c) c (zipLists hexChars (range 0 (length hexChars - 1)))).snd;
    fromHex = s: foldl (a: b: a * 16 + fromHexDigit b) 0 (stringToCharacters (toLower s));

    # Breakup into 2-byte integer chunks. Needs an even length string of hex digits
    bytes = hexstr: map (n: fromHex (substring (2 * n) 2 hexstr)) (range 0 (((stringLength hexstr) / 2) - 1));

    # Convert an "nwid" as a list of 8 integers into "nwid40" as a list of 5 integers
    nwid40 = lst: [
      (bitXor (elemAt lst 0) (elemAt lst 3))
      (bitXor (elemAt lst 1) (elemAt lst 4))
      (bitXor (elemAt lst 2) (elemAt lst 5))
      (bitXor (elemAt lst 3) (elemAt lst 6))
      (bitXor (elemAt lst 4) (elemAt lst 7))
    ];

    # base32 stuff from zerotier osdep/LinuxEthernetTap.cpp
    # Convert a list of 5 integers to a string containing 8 base32 characters
    toBase32 = lst:
      concatStrings (map (n: (elemAt base32Chars n)) [
        ((elemAt lst 0) / 8)
        (bitOr ((bitAnd (elemAt lst 0) (fromHex "07")) * 4) ((bitAnd (elemAt lst 1) (fromHex "c0")) / 64))
        ((bitAnd (elemAt lst 1) (fromHex "3e")) / 2)
        (bitOr ((bitAnd (elemAt lst 1) (fromHex "01")) * 16) ((bitAnd (elemAt lst 2) (fromHex "f0")) / 16))
        (bitOr ((bitAnd (elemAt lst 2) (fromHex "0f")) * 2) ((bitAnd (elemAt lst 3) (fromHex "80")) / 128))
        ((bitAnd (elemAt lst 3) (fromHex "7c")) / 4)
        (bitOr ((bitAnd (elemAt lst 3) (fromHex "03")) * 8) ((bitAnd (elemAt lst 4) (fromHex "e0")) / 32))
        (bitAnd (elemAt lst 4) (fromHex "1f"))
      ]);
  in
    nwid: "zt" + (toBase32 (nwid40 (bytes nwid)));
in {
  options.zerotier.network-interfaces = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "Mapping of ZeroTier network IDs to interface names";
    readOnly = true;
    default = builtins.listToAttrs (builtins.map (nwid: lib.nameValuePair nwid (ifrname nwid)) config.services.zerotierone.joinNetworks);
  };
  config = {
    services.zerotierone = {
      enable = true;
      joinNetworks = builtins.attrNames zerotier-networks;
    };

    # enable networkd and have it configure the specified DNS servers on the zt* interfaces
    systemd.network = {
      enable = true;
      # using systemd-networkd causes multi-user.target to wait for a configured interface to come online
      # by default, no interfaces are configured, and the service waits until timeout
      wait-online.enable = lib.mkDefault false;
      networks =
        lib.mapAttrs' (
          nwid: ztConfig:
            lib.nameValuePair
            "50-${ifrname nwid}"
            {
              name = ifrname nwid;
              dns = ztConfig.config.dns.servers;
              domains = [ztConfig.config.dns.domain];
              networkConfig = {
                DNSDefaultRoute = false; # only use this dns server for lookups on specified domain, never as catch-all
                KeepMaster = true;
                KeepConfiguration = true;
              };
              linkConfig = {
                ActivationPolicy = "manual";
                RequiredForOnline = false;
              };
            }
        )
        zerotier-networks;
    };

    # resolved is needed for networkd's dns assignments to take effect
    services.resolved = {
      enable = true;
      extraConfig = "MulticastDNS=false"; # we have avahi nss
    };
  };
}
