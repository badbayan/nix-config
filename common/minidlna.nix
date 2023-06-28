{ lib, ... }:
with lib;
{
  services.minidlna = {
    openFirewall = mkDefault true;
    settings = {
      inotify = mkDefault "yes";
      root_container = mkDefault "B";
    };
  };
}
