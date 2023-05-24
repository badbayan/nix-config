{
  description = "NixOS configuration";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.follows = "stable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, unstable, emacs-overlay, ... } @ inputs:
    let
      specialArgs = { inherit inputs; };
      mkSystem = system: conf: nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ unstable-overlay ]; })
          conf
        ];
      };
      unstable-overlay = final: prev: {
        unstable = unstable.legacyPackages.${prev.system};
      };
    in {
      nixosConfigurations = {
        yama = mkSystem "x86_64-linux" ./hosts/yama.nix;
      };
    };
}
