{
  self,
  nixosModules,
  nixos-unstable,
  home-configs,
  ...
} @ inputs:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({pkgs, config, modulesPath, ...}: {
      imports = with nixosModules; [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")

        ### SETTINGS ###
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        power-management
        sudo-disable-timeout

        ### FEATURES ###
        cloudflare-warp
        console
        ios-usb
        docker

        ### USERS ###
        (home-configs.setup-module "unstable" {
          nixos = {
            hmCfg = {homeModules, pkgs, ...}: {
              imports = with homeModules; [
                cli-programs
                colors
              ];

              xdg.enable = true;

              home.packages = with pkgs; [
                powershell
                wimlib
              ];
            };
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-toolbox";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";

      ### BOOT CUSTOMIZATION ###
      system.nixos.tags = [ config.networking.hostName (toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown")) ];

      ### ENVIRONMENT CUSTOMIZATION ###
      virtualisation.libvirtd.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
    })
  ];
}
