flake: let
  inherit (flake.inputs) nixpkgs;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit flake; };
  modules = builtins.attrValues { inherit (flake.nixosModules)
    ### SETTINGS ###
    enable-standard-hardware
    locale-sg
    nix-enable-flakes
    nix-gc
    plymouth
    power-management
    sudo-disable-timeout

    ### FEATURES ###
    cloudflare-warp
    console
    containers
    enable-via-qmk
    home-manager-users
    hyprland
    ios-usb
    sshd
    stylix
  ;} ++ [
    ({lib, pkgs, config, ...}: {
      networking.hostName = "jeshua-toolbelt";
      system.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";

      ### ENVIRONMENT CUSTOMIZATION ###
      virtualisation.libvirtd.enable = true;
      programs.wireshark.enable = true;
      stylix.image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/e7/wallhaven-e7651w.jpg";
        hash = "sha256-RmrNy9hjIVvN8hfDaFMakTWCV0Ln8e0oBgEo8hZWPyA=";
      };

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      hmUsers.nixos = {
        extraGroups = ["podman" "wireshark"];
        openssh.authorizedKeys.keys = lib.splitString "\n" (lib.readFile (pkgs.fetchurl {
          url = "https://github.com/jeslinmx.keys";
          hash = "sha256-iMuMcvz+q3BPKtsv0ZXBzy6Eps4uh9Fj7z92wdONZq4=";
        }));
        hmModules = (builtins.attrValues { inherit (flake.homeModules)
            cli-programs
            kitty
            termshark
            ;
          }) ++ [{
            xdg.enable = true;
          home.packages = builtins.attrValues { inherit (pkgs)
            powershell
            wimlib
          ;};
        }];
      };
    })
  ];
}
