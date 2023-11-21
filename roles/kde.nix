{ config, lib, ... }:
with lib;
{
  config = mkIf (config.roles.desktop == "kde") {
    programs.gnupg.agent.pinentryFlavor = "qt";

    boot.plymouth.theme = "breeze";

    services.xserver = {
      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm.enable = true;
      };
    };
  };
}
