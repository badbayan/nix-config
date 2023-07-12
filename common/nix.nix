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
