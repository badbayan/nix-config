{ pkgs, inputs, ... }:

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
    "/".options = [ "size=1G" "mode=755" ];
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
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/system" ];
    };
    dnsmasq.enable = true;
    yggdrasil.enable = true;
  };

  zramSwap.enable = true;
}
