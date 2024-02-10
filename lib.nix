{ inputs, ... }:

rec {
  specialArgs = { inherit inputs; };
  forAllSystems = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed;

  listDir = dir: builtins.attrNames (builtins.readDir dir);
  match' = regex: builtins.match ("(.*)" + regex);
  endsWith = regex: str: match' regex str != null;
  desuffix = regex: str: if (endsWith regex str) then
    (builtins.head (match' regex str)) else str;
  hasSuffix = regex: dir: name:
    builtins.pathExists (dir + "/${name}") && endsWith regex name;
  isModule = dir: name:
    builtins.pathExists (dir + "/${name}/default.nix") ||
    (hasSuffix "\\.nix" dir name && name != "default.nix");
  filterDir = regex: dir: builtins.filter
    ((if regex == "\\.nix"
      then isModule
      else hasSuffix regex
    ) dir) (listDir dir);
  asAttrs = regex: dir: builtins.listToAttrs
    (map (name: {
      name = desuffix regex name;
      value = dir + "/${name}";
    }) (filterDir regex dir));
  asList = regex: dir: builtins.attrValues (asAttrs regex dir);

  mkSystem = system: conf: inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      inputs.agenix.nixosModules.age
      inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
    ] ++ (builtins.concatLists [
      (asList "\\.nix" ./common)
      (asList "\\.nix" ./roles)
      (asList "\\.nix" ./services)
      conf
    ]);
  };
}
