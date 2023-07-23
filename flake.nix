{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-stable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    #emacs-overlay = {
    #  url = "github:nix-community/emacs-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    #};
  };

  outputs = inputs @
    { self
    , nixpkgs
    #, nixpkgs-unstable
    , home-manager
    , agenix
    #, emacs-overlay
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
        modules = ([
          ({ nixpkgs.overlays = [
               #(self: super: {
               #  nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${super.system};
               #})
               #emacs-overlay.overlay
             ];})
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          agenix.nixosModules.default
          conf
        ]) ++ (builtins.concatLists [
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
        nixos = mkSystem "x86_64-linux" ./hosts/nixos;
        shrine = mkSystem "x86_64-linux" ./hosts/shrine;
        yama = mkSystem "x86_64-linux" ./hosts/yama;
      };
    };
}
