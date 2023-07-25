{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    users.aya
  ];

  roles.gnome.enable = true;

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
      timeout = 2;
    };
    kernelPackages = pkgs.linuxPackages_5_10;
    kernelParams = [ "acpi_backlight=native" ];
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager"
      "/var/lib"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  fileSystems = {
    "/".options = [ "size=1G" "mode=755" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/persist" = {
      neededForBoot = true;
      options = [ "compress=zstd" ];
    };
  };

  networking = {
    hostName = "makai";
    networkmanager.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;
    yggdrasil = {
      enable = true;
      persistentKeys = true;
    };
  };

  zramSwap.enable = true;
}
