{ config, lib, pkgs, ... }:
with lib;
{
  boot = {
    consoleLogLevel = mkDefault 0;
    initrd = {
      systemd.enable = mkIf config.boot.plymouth.enable true;
      verbose = mkDefault false;
    };
    kernelPackages = mkDefault pkgs.linuxPackages_6_6;
    kernelParams = [ "boot.shell_on_fail" "quiet" ];
    loader = {
      efi.canTouchEfiVariables = mkDefault false;
      systemd-boot.configurationLimit = mkDefault 100;
      timeout = mkDefault 2;
    };
    plymouth = {
      enable = mkDefault false;
      font = mkDefault "${pkgs.cantarell-fonts}/share/fonts/cantarell/Cantarell-VF.otf";
    };
    tmp.useTmpfs = mkDefault true;
  };
}
