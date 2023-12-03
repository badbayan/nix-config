{ config, lib, ... }:
with lib;
{
  config = mkIf (config.roles.desktop == "kde") {
    boot.plymouth.theme = "breeze";

    services.xserver = {
      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm.enable = true;
      };
    };

    qt = {
      enable = true;
      platformTheme = "kde";
      style = "breeze";
    };
  };
}
