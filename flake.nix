{
  description = "NixOS configuration";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    #unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "stable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @
    { self
    , nixpkgs
    #, unstable
    , home-manager
    , emacs-overlay
    , ... }: let
      specialArgs = { inherit inputs; };
      #unstable-overlay = final: prev: {
      #  unstable = unstable.legacyPackages.${prev.system};
      #};
      mkSystem = system: conf: nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ({ nixpkgs.overlays = [
               #unstable-overlay
               emacs-overlay.overlay
             ];})
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          conf
        ];
      };
    in {
      home = import ./home;
      roles = import ./roles;
      services = import ./services;
      users = import ./users;

      nixosConfigurations = {
        yama = mkSystem "x86_64-linux" ./hosts/yama;
      };
    };
}
