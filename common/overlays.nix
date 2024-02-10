{ inputs, ... }:

{
  nixpkgs.overlays = (builtins.attrValues inputs.self.overlays) ++ [
    (_: super: {
      # unstable = inputs.nixpkgs-unstable.legacyPackages.${super.system};
    })
  ];
}
