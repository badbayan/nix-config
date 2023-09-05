{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      lsDir = dir:
        builtins.removeAttrs (builtins.listToAttrs (builtins.concatLists (builtins.attrValues
          (builtins.mapAttrs (name: type:
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
          nix-index-database.nixosModules.nix-index {
            programs.nix-index-database.comma.enable = true;
          }
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          impermanence.nixosModule
          agenix.nixosModules.default
        ] ++ conf ++ (builtins.concatLists [
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

      nixosConfigurations = {
        nixos = mkSystem "x86_64-linux" [ ./hosts/nixos ];
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
