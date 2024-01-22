{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-stable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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

  outputs = inputs @ { self , nixpkgs , nixos-hardware , ... }:
    let
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
          inputs.agenix.nixosModules.default
          inputs.flake-programs-sqlite.nixosModules.programs-sqlite
          inputs.home-manager.nixosModules.home-manager
          inputs.impermanence.nixosModules.impermanence
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

      packages = nixpkgs.lib.recursiveUpdate (forAllSystems (system:
        with import nixpkgs { inherit system; }; {
          default = writeShellScriptBin "fmt-check" ''
            ${deadnix}/bin/deadnix ${self}
            ${statix}/bin/statix check -i hardware-configuration.nix -- ${self}
          '';
        })) {
          x86_64-linux = let
            mkIso = edition: conf: (mkSystem "x86_64-linux" ([
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if (edition == "minimal") then "minimal" else "base"}.nix"
              ./hosts/nixos ({ lib, pkgs, ... }: {
                isoImage = {
                  inherit edition;
                  isoBaseName = "nixos-${edition}";
                  squashfsCompression = "zstd -Xcompression-level 3";
                };
                environment.systemPackages = lib.mkIf
                  (edition != "minimal") (with pkgs; [ gparted ]);
              })
            ] ++ conf)).config.system.build.isoImage;
            mkVm = conf: (mkSystem "x86_64-linux" ([
              "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
              ./hosts/nixos {
                virtualisation = {
                  cores = 2;
                  memorySize = 4096;
                };
              }
            ] ++ conf)).config.system.build.vm;
          in {
            iso = mkIso "minimal" [];
            iso-gnome = mkIso "gnome" [{ roles.desktop = "gnome"; }];
            iso-kde = mkIso "plasma5" [{ roles.desktop = "kde"; }];
            vm = mkVm [{ virtualisation.qemu.options = [ "-nographic" ]; }];
            vm-gnome = mkVm [{
              virtualisation.qemu.options = [ "-vga virtio" ];
              roles.desktop = "gnome";
            }];
            vm-kde = mkVm [{
              virtualisation.qemu.options = [ "-vga virtio" ];
              roles.desktop = "kde";
            }];
          };
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
