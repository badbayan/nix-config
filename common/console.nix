{ config, lib, ... }:
with lib;
{
  console = {
    earlySetup = mkDefault true;
    font = mkDefault "UniCyrExt_8x16";
    useXkbConfig = mkDefault config.services.xserver.enable;
  };
}
