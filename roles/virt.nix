{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.roles.virt;
in {
  options.roles.virt.enable = mkOption {
    default = false;
    type = types.bool;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman
      qemu
      virt-manager
    ];

    virtualisation = {
      containers.enable = true;
      libvirtd.enable = true;
    };
  };
}
