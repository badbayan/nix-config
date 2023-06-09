{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    users.hatate
  ];

  roles.gnome.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    extraModprobeConfig = "options iwlwifi disable_11ax=true";
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "acpi_backlight=native" ];
  };

  networking = {
    hostName = "shrine";
    networkmanager.enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "Mon,Fri 18:00";
    flake = "github:badbayan/nix-config#shrine";
    operation = "boot";
  };

  security.sudo.wheelNeedsPassword = false;
  services.fstrim.enable = true;
  zramSwap.enable = true;
}
