{ pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    users.hatate
  ];

  roles.desktop = "gnome";

  documentation.doc.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  boot = {
    loader.systemd-boot.enable = true;
    # extraModprobeConfig = "options iwlwifi disable_11ax=true";
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "acpi_backlight=native" ];
  };

  hardware.firmware = with pkgs; let
    firmware = compressFirmwareXz linux-firmware;
    ibt-0040-1050 = runCommand "ibt-${linux-firmware.version}" {} ''
      mkdir -p $out/lib/firmware/intel
      cd $out/lib/firmware/intel
      for ext in ddc sfi; do
        ln -sf ${firmware}/lib/firmware/intel/ibt-1040-4150.$ext ibt-0040-1050.$ext
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
