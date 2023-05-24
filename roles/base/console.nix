{ config, ... }:

{
  console = {
    earlySetup = true;
    font = "UniCyrExt_8x16";
    useXkbConfig = config.services.xserver.enable;
  };
}
