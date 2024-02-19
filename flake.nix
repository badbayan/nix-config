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

  outputs = inputs @ { self, nixpkgs, nixos-hardware, ... }:
    let inherit (import ./lib.nix { inherit inputs; })
      forAllSystems isDir listDir asAttrs mkSystem;
    in {
      modules = builtins.listToAttrs (builtins.map (s: {
        name = builtins.baseNameOf s;
        value = asAttrs "\\.nix" s;
      }) (builtins.filter isDir (listDir ./modules))) // {
        secrets = asAttrs "\\.age" ./secrets;
      };

      overlays = builtins.mapAttrs (_: import) (asAttrs "\\.nix" ./overlays);

      devShells = forAllSystems (system:
        with import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        }; {
          default = mkShell {
            nativeBuildInputs = with pkgs; [
              inputs.agenix.packages.${system}.agenix
              inputs.home-manager.packages.${system}.home-manager
              deadnix
              statix
              vim-with-vimrc
            ];
          };
        });

      packages = nixpkgs.lib.recursiveUpdate (forAllSystems (system:
        with import nixpkgs { inherit system; }; {
          default = writeShellScriptBin "fmt-check" ''
            ${deadnix}/bin/deadnix ${self}
            ${statix}/bin/statix check -i hardware-configuration.nix -- ${self}
          '';
        })) (import ./packages.nix { inherit inputs; });

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
