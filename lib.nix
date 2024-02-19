{ inputs, ... }:

rec {
  specialArgs = { inherit inputs; };
  forAllSystems = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed;

  match' = regex: builtins.match ("(.*)" + regex);
  endsWith = regex: str: match' regex (if builtins.isPath str then
    builtins.baseNameOf str else str) != null;
  desuffix = regex: str: if (endsWith regex str) then
    (builtins.head (match' regex str)) else str;
  isDir = path: builtins.readFileType path == "directory";
  listDir = path: builtins.concatMap (n: [ (path + "/${n}") ])
    (builtins.attrNames (if isDir path then builtins.readDir path else {}));
  recListDir = path: builtins.concatMap (n:
    if isDir n then recListDir n else [ n ]) (listDir path);
  asAttrs = regex: path: builtins.listToAttrs
    (builtins.map (n: {
      name = desuffix regex (builtins.baseNameOf n);
      value = n;
    }) (builtins.filter (s: endsWith regex s && !isDir s) (listDir path)));

  mkSystem = system: conf: inputs.nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      inputs.agenix.nixosModules.age
      inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
    ] ++ (builtins.filter (endsWith "\\.nix") (recListDir ./nixos)) ++ conf;
  };
}
