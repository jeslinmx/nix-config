{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs
    nixpkgs.url = "nixpkgs/release-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/cozette-psfu";
    nixpkgs-caddy-plugins.url = "nixpkgs/b8a14976023e53f6e08e51dc61585838eb1f2828";

    # nix-darwin modules
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private-config = {
      url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Supporting repos
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    arcwtf = {
      url = "github:kikaraage/arcwtf/v1.3-firefox";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    devshell,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = [
        devshell.flakeModule
      ];

      flake = let
        inherit (self.lib) gatherModules;
      in {
        darwinModules = gatherModules ./modules/darwin;
        nixosModules = gatherModules ./modules/nixos;
        homeModules = gatherModules ./modules/home-manager;

        darwinConfigurations = builtins.mapAttrs (_: v:
          inputs.nix-darwin.lib.darwinSystem {modules = [v];}) {
          jeshua-macbook = ./systems/jeshua-macbook;
        };
        nixosConfigurations = builtins.mapAttrs (_: v:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [((import v) self)];
          }) {
          app-server = ./systems/app-server;
          docker-devbox = ./systems/docker-devbox;
          jeshua-toolbelt = ./systems/jeshua-toolbelt;
          jeshua-xps-9510 = ./systems/jeshua-xps-9510;
          speqtral-devbox = ./systems/speqtral-devbox;
        };

        lib = {
          dirToAttrs = path:
            lib.pipe path [
              builtins.readDir
              (builtins.mapAttrs (
                name: type: let
                  fullPath = /${path}/${name};
                in
                  if type == "directory"
                  then self.lib.dirToAttrs fullPath
                  else fullPath
              ))
            ];
          filterNonNix = lib.filterAttrsRecursive (_: v: !(builtins.isPath v) || lib.hasSuffix ".nix" "${v}");
          filterEmptySubdirs = lib.filterAttrsRecursive (_: v: builtins.isPath v || builtins.length (builtins.attrNames v) != 0);
          flattenAttrs = let
            recurse = sep: prefix:
              lib.foldlAttrs (
                acc: n: v: let
                  fullPath = builtins.concatStringsSep sep (prefix ++ [n]);
                in
                  acc
                  // (
                    if builtins.isPath v
                    then {${fullPath} = v;}
                    else recurse sep [fullPath] v
                  )
              ) {};
          in
            sep: recurse sep [];
          truncateSuffix = lib.mapAttrs' (n: v: lib.nameValuePair (lib.pipe n [(lib.removeSuffix ".nix") (lib.removeSuffix "-default")]) v);
          gatherModules = lib.flip lib.pipe [
            self.lib.dirToAttrs
            self.lib.filterNonNix
            self.lib.filterEmptySubdirs
            (self.lib.flattenAttrs "-")
            self.lib.truncateSuffix
            (builtins.mapAttrs (_: import))
            (builtins.mapAttrs (_: v: v self))
          ];
        };
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        packages.osx-kvm = let
          osx-kvm = pkgs.fetchFromGitHub {
            owner = "kholia";
            repo = "OSX-KVM";
            rev = "adde00327ac767b012d8e5cab114db4acd129f6f";
            hash = "sha256-jNtZxsJd9FwFrhQvtyll294d+ix+csA5kfyxg0wOwcU=";
          };
        in (pkgs.writeShellScriptBin "osx-kvm" ''
          set -euo pipefail
          OSX_KVM_DIR="$HOME/.local/share/osx-kvm"
          pushd "$OSX_KVM_DIR" 2> /dev/null

          # copy OpenCore-Boot.sh dependencies to OSX_KVM_DIR
          install -Dm644 -t .          ${osx-kvm}/OVMF_CODE.fd ${osx-kvm}/OVMF_VARS-1920x1080.fd
          install -Dm644 -t ./OpenCore ${osx-kvm}/OpenCore/OpenCore.qcow2

          # create BaseSystem.img from dmg if needed
          if [ ! -e ./BaseSystem.img ];then
            if [ ! -e ./BaseSystem.dmg ];then
              install -Dm644 -t . ${osx-kvm}/fetch-macOS-v2.py
              ${lib.getExe pkgs.python3} ./fetch-macOS-v2.py && rm ./fetch-macOS-v2.py
            fi
            ${lib.getExe' pkgs.qemu "qemu-img"} convert ./BaseSystem.dmg -O raw ./BaseSystem.img && rm ./BaseSystem.dmg
          fi

          # create macOS drive if needed
          if [ ! -e ./mac_hdd_ng.img ];then
            ${lib.getExe' pkgs.qemu "qemu-img"} create -f qcow2 ./mac_hdd_ng.img 128G
          fi

          # create and define libvirt domain if needed
          sed \
            -e "s|/home/CHANGEME/OSX-KVM|$OSX_KVM_DIR|g" \
            -e "s|/usr/bin/qemu-system-x86_64|${lib.getExe' pkgs.qemu "qemu-system-x86_64"}|g" \
            -e "s|OVMF_VARS.fd|OVMF_VARS-1920x1080.fd|g" \
            ${osx-kvm}/macOS-libvirt-Catalina.xml > ./macOS.xml
          ${lib.getExe' pkgs.libvirt "virt-xml-validate"} ./macOS.xml
          ${lib.getExe' pkgs.libvirt "virsh"} --connect qemu:///system define ./macOS.xml

          popd 2> /dev/null
        '');

        devshells.default = {
          commands = [
            {
              name = "deploy-server";
              category = "build";
              help = "Rebuild and switch <app-server> config";
              command = ''
                nixos-rebuild switch --flake $PRJ_ROOT#''${1:-app-server} --target-host ''${1:-app-server} ''${@:2}
              '';
            }
            {
              name = "build-image";
              category = "build";
              help = "Build <jeshua-toolbelt> <install-iso> image for ${system}";
              command = ''
                ${inputs.nixos-generators.apps.${system}.nixos-generate.program} \
                  --flake $PRJ_ROOT#''${1:-jeshua-toolbelt} \
                  --format ''${2:-install-iso} \
                  --system ''${3:-${system}} \
                  --show-trace
              '';
            }
            {
              package = pkgs.nurl;
              category = "dev";
            }
            {
              package = pkgs.sops;
              category = "dev";
            }
            {
              package = pkgs.nh;
              category = "build";
            }
            {
              package = pkgs.nix-tree;
              category = "debug";
            }
            {
              package = pkgs.nix-melt;
              category = "debug";
            }
            {package = self.packages.${system}.osx-kvm;}
          ];
          packages = [pkgs.nixd];
          env = [
            {
              name = "RULES";
              eval = "$PRJ_ROOT/secrets.nix";
            }
          ];
        };
      };
    });
}
