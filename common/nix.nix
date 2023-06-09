{ lib, inputs, ... }:
with lib;
{
  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = mkDefault true;

  virtualisation.vmVariant.virtualisation = {
    cores = mkDefault 2;
    memorySize = mkDefault 4096;
  };

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = mkBefore [
        "https://nix.badbayan.duckdns.org/"
      ];
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
