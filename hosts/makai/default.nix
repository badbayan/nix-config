{ lib, pkgs, inputs, ... }:

{
  imports = with inputs.self.modules; [
    ./hardware-configuration.nix

    users.aya
  ];

  roles.desktop = "gnome";

  nix.gc.automatic = lib.mkForce false;

  boot = {
    loader = {
      # grub = {
      #   enable = true;
      #   device = "/dev/sda";
      # };
      systemd-boot = {
        enable = true;
        extraEntries = {
          "shell.conf" = ''
            title UEFI Shell
            efi /efi/shell/shell.efi
          '';
        };
        extraFiles = {
          "efi/clover/cloverx64.efi" = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-bootx64.efi";
          "efi/shell/shell.efi" = pkgs.edk2-uefi-shell.efi;
        };
      };
      timeout = 2;
    };
    kernelPackages = pkgs.linuxPackages_6_6;
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
