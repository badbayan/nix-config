{ lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    users.aya
  ];

  roles.desktop = "gnome";

  nix.gc.automatic = lib.mkForce false;

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    kernelPackages = pkgs.linuxPackages_6_1;
    kernelParams = [ "acpi_backlight=native" ];
  };

  environment.persistence."/system/persist" = {
    directories = [
      "/etc/NetworkManager"
      "/var/db/sudo"
      "/var/lib"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  fileSystems = {
    "/".options = [ "size=256M" "mode=755" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/system" = {
      neededForBoot = true;
      options = [ "compress=zstd" ];
    };
  };

  networking = {
    hostName = "makai";
    networkmanager.enable = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  services = {
    # btrfs.autoScrub = {
    #   enable = true;
    #   fileSystems = [ "/system" ];
    # };
    dnsmasq.enable = true;
    yggdrasil.enable = true;
  };

  zramSwap.enable = true;
}
