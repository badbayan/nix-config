{ lib, ... }:
with lib;
{
  services.openssh = {
    openFirewall = mkDefault true;
    settings.PasswordAuthentication = mkDefault false;
  };
}
