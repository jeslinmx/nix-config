{
  nixosModules,
  nixos-unstable,
  nixos-generators,
  home-configs,
  ...
} @ inputs:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({pkgs, modulesPath, ...}: {
      imports = ( builtins.attrValues { inherit (nixosModules)
        ### SETTINGS ###
        locale-sg
        nix-enable-flakes
        nix-gc
        sudo-disable-timeout

        ### FEATURES ###
        enable-via-qmk
        stylix
        wireshark
      ; }) ++ [
        (modulesPath + "/virtualisation/proxmox-lxc.nix")
        nixos-generators.nixosModules.all-formats
        (home-configs.setup-module "unstable" {
          jeshua = {
            uid = 1000;
            description = "Jeshua Lin";
            extraGroups = ["wheel" "scanner" "lp" "wireshark"];
            openssh.authorizedKeys.keyFiles = [
              (pkgs.fetchurl {
                url = "https://github.com/jeslinmx.keys";
                hash = "sha256-iMuMcvz+q3BPKtsv0ZXBzy6Eps4uh9Fj7z92wdONZq4=";
              }).outPath
            ];
            hmCfg = {homeModules, privateHomeModules, pkgs, ...}: {
              imports = [
                homeModules.cli-programs
                privateHomeModules.awscli
              ];

              xdg.enable = true;

              home.packages = builtins.attrValues { inherit (pkgs)
                powershell
                wimlib
              ;};
            };
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-devbox";
      nixpkgs.config.allowUnfree = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      stylix.image = ../jeshua-speqtral/wallpaper.png;
    })
  ];
}
