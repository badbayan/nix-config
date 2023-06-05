{
  description = "NixOS configuration";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    #unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "stable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @
    { self
    , nixpkgs
    #, unstable
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
          conf
        ];
      };
    in {
      roles = import ./roles;
      services = import ./services;
      nixosConfigurations = {
        yama = mkSystem "x86_64-linux" ./hosts/yama;
      };
    };
}
