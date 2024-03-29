{ config, lib, inputs, ... }:
with lib;
{
  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = mkDefault true;

  virtualisation.vmVariant.virtualisation = {
    cores = mkDefault 2;
    memorySize = mkDefault 4096;
  };

  environment = {
    sessionVariables.NIXPKGS_ALLOW_UNFREE = mkDefault "1";
  };

  nix = {
    # channel.enable = false;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];

    registry = {
      nix-config.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home-manager;
      agenix.flake = inputs.agenix;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = mkIf (!config.services.nix-serve.enable) (mkBefore [
        "https://nix.badbayan.duckdns.org/?priority=50"
      ]);
      trusted-public-keys = mkBefore [
        "nix.badbayan.duckdns.org-1:qI75l0GHxICLk1ftwwL1rPqcml+krIzOtZdrRs9Zrlk="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024 * 4)}
    '';
  };
}
