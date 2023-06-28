{ lib, pkgs, ... }:
with lib;
{
  boot = {
    consoleLogLevel = mkDefault 0;
    initrd = {
      #systemd.enable = mkDefault true;
      verbose = mkDefault false;
    };
    kernelPackages = mkDefault pkgs.linuxPackages_5_15;
    kernelParams = [ "boot.shell_on_fail" "quiet" ];
    loader = {
      efi.canTouchEfiVariables = mkDefault false;
      systemd-boot.configurationLimit = mkDefault 100;
      timeout = mkDefault 0;
    };
    #plymouth.enable = mkDefault true;
    tmp.useTmpfs = mkDefault true;
  };
}
