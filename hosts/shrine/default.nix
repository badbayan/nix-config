{ pkgs, inputs, ... }:

{
  imports = with inputs.self.modules; [
    ./hardware-configuration.nix

    users.taisa
  ];

  roles.desktop = "kde";

  documentation = {
    doc.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  boot = {
    loader.systemd-boot.enable = true;
    extraModprobeConfig = "options iwlwifi disable_11ax=true";
    kernelPackages = pkgs.linuxPackages_6_6;
    kernelParams = [ "acpi_backlight=native" ];
  };

  hardware.firmware = with pkgs; let
    firmware = compressFirmwareXz linux-firmware;
    ibt-0040-1050 = runCommand "ibt-${linux-firmware.version}" {} ''
      mkdir -p $out/lib/firmware/intel
      cd $out/lib/firmware/intel
      for ext in ddc sfi; do
        xzcat ${firmware}/lib/firmware/intel/ibt-1040-4150.$ext.xz > ibt-0040-1050.$ext
      done
    '';
  in [ ibt-0040-1050 ];

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
  zramSwap.enable = true;
}
