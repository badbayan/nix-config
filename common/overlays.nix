{ inputs, ... }:

{
  nixpkgs.overlays = (builtins.attrValues inputs.self.overlays) ++ [
    (_: _: {
      # unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
    })
  ];
}
