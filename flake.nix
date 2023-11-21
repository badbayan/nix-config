{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-stable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @
    { self
    , nixpkgs
    , nixos-hardware
    , nix-index-database
    , home-manager
    , impermanence
    , agenix
    , ... }: let
      specialArgs = { inherit inputs; };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      lsDir = dir:
        builtins.removeAttrs (builtins.listToAttrs (builtins.concatLists
          (builtins.attrValues (builtins.mapAttrs (name: type:
            if type == "regular" then [{
              name = builtins.elemAt (builtins.match "(.*)\\..*" name) 0;
              value = dir + "/${name}";
            }] else [{
              name = type;
              value = type;
            }]) (builtins.readDir dir)))))
          [ "flake" "default" "secrets" "directory" "symlink" "unknown" ];
      lsModules = dir: builtins.attrValues (lsDir dir);
      mkSystem = system: conf: nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          nix-index-database.nixosModules.nix-index
          ({ config, lib, ... }: {
            home-manager = {
              sharedModules = with lib; with self.home;
                mkForce (builtins.concatLists [
                  [({ lib, ... }: {
                    fonts.fontconfig.enable = false;
                    home.activation.zshrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                      if [[ ! -e $HOME/.zshrc ]]; then
                        $DRY_RUN_CMD touch $HOME/.zshrc
                      fi
                    '';
                    home.stateVersion = config.system.stateVersion;
                  }) git ]
                  (optionals (config.roles.desktop != null) [
                    chromium mpv terminals xdg xresources zathura
                  ])
                  (optionals (config.roles.desktop == "gnome") [
                    dconf gtk
                  ])
                ]);
              useGlobalPkgs = true;
              useUserPackages = true;
            };
            programs.nix-index-database.comma.enable = true;
            nixpkgs.overlays = (builtins.attrValues self.overlays) ++ [
              (_: super: {
                # unstable = inputs.nixpkgs-unstable.legacyPackages.${super.system};
              })
            ];
          })
        ] ++ (builtins.concatLists [
          conf
          (lsModules ./common)
          (lsModules ./roles)
          (lsModules ./services)
        ]);
      };
    in {
      domains = lsDir ./domains;
      home = lsDir ./home;
      secrets = lsDir ./secrets;
      users = lsDir ./users;

      overlays = builtins.mapAttrs (_: import) (lsDir ./overlays);

      hydraJobs = builtins.mapAttrs (_: host:
        host.config.system.build.toplevel) self.nixosConfigurations;

      devShells = forAllSystems (system:
        with import nixpkgs { inherit system; }; {
          default = mkShell {
            nativeBuildInputs = with pkgs; [
              deadnix
              statix
              agenix.packages.${system}.agenix
            ];
          };
        });

      packages.x86_64-linux = {
        iso = (mkSystem "x86_64-linux" [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./hosts/nixos {
            isoImage.squashfsCompression = "zstd -Xcompression-level 3";
          }
        ]).config.system.build.isoImage;
        iso-gnome = (mkSystem "x86_64-linux" [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
          ./hosts/nixos {
            isoImage = {
              edition = "gnome";
              squashfsCompression = "zstd -Xcompression-level 3";
            };
            roles.desktop = "gnome";
          }
        ]).config.system.build.isoImage;
        inherit ((mkSystem "x86_64-linux" [
          "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ./hosts/nixos {
            virtualisation = {
              cores = 2;
              memorySize = 4096;
              qemu.options = [ "-nographic" ];
            };
          }
        ]).config.system.build) vm;
        vm-gnome = (mkSystem "x86_64-linux" [
          "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ./hosts/nixos {
            virtualisation = {
              cores = 2;
              memorySize = 4096;
              qemu.options = [ "-vga virtio" ];
            };
            roles.desktop = "gnome";
          }
        ]).config.system.build.vm;
      };

      nixosConfigurations = {
        makai = mkSystem "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
          nixos-hardware.nixosModules.common-pc-laptop-hdd
          ./hosts/makai
        ];
        shrine = mkSystem "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          ./hosts/shrine
        ];
        yama = mkSystem "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          ./hosts/yama
        ];
      };
    };
}
