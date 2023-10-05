{ lib, ... }:
with lib;
{
  console = {
    earlySetup = mkDefault true;
    font = mkDefault "UniCyrExt_8x16";
    useXkbConfig = mkDefault true;
  };

  services.xserver = {
    autoRepeatDelay = mkDefault 300;
    autoRepeatInterval = mkDefault 20;
    layout = mkDefault "us,ru";
    xkbOptions = mkDefault "ctrl:nocaps,grp:alts_toggle,grp_led:caps,misc:typo,srvrkeys:none";
    xkbVariant = mkDefault "";
  };
}
