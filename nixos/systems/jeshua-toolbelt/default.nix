{ flake, lib, pkgs, ... }: {
  imports = builtins.attrValues { inherit (flake.nixosModules)
    ### SETTINGS ###
    enable-standard-hardware
    locale-sg
    nix-enable-flakes
    nix-gc
    power-management
    sudo-disable-timeout

    ### FEATURES ###
    console
    containers
    enable-via-qmk
    home-manager-users
    hyprland
    ios-usb
    sshd
    stylix
  ;};

  networking.hostName = "jeshua-toolbelt";
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  ### ENVIRONMENT CUSTOMIZATION ###
  virtualisation.libvirtd.enable = true;
  programs.wireshark.enable = true;
  networking.networkmanager.enable = lib.mkForce false; # https://github.com/nix-community/nixos-generators/issues/281
    services.openssh.settings.PermitRootLogin = lib.mkForce "no"; # override install-iso default
    stylix.image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/e7/wallhaven-e7651w.jpg";
      hash = "sha256-RmrNy9hjIVvN8hfDaFMakTWCV0Ln8e0oBgEo8hZWPyA=";
    };

  ### USER SETUP ###
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  hmUsers.nixos = {
    extraGroups = ["podman" "wireshark"];
    openssh.authorizedKeys.keys = flake.inputs.private-config.ssh-authorized-keys;
    hmModules = (builtins.attrValues { inherit (flake.homeModules)
        cli-programs
        kitty
        ;
        }) ++ [{
      xdg.enable = true;
      home.packages = builtins.attrValues { inherit (pkgs)
        powershell
          wimlib
          ;};
    }];
  };
}
