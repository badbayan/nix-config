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
    #, emacs-overlay
    , ... }: let
      specialArgs = { inherit inputs; };
      lsNix = dir:
        builtins.listToAttrs (builtins.concatLists (builtins.attrValues
          (builtins.mapAttrs (name: value: [{
            name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
            value = dir + "/${name}";
          }]) (builtins.readDir dir))));
      lsModules = dir: builtins.attrValues (lsNix dir);
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
          conf
        ]) ++ (builtins.concatLists [
          (lsModules ./common)
          (lsModules ./roles)
          (lsModules ./services)
        ]);
      };
    in {
      domains = lsNix ./domains;
      home = lsNix ./home;
      users = lsNix ./users;

      nixosConfigurations = {
        nixos = mkSystem "x86_64-linux" ./hosts/nixos;
        yama = mkSystem "x86_64-linux" ./hosts/yama;
      };
    };
}
