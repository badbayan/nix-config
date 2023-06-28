{ lib, ... }:
with lib;
{
  services.yggdrasil = {
    persistentKeys = mkDefault true;
    settings.Peers = mkDefault [
      "tcp://itcom.multed.com:7991"
      "tcp://srv.itrus.su:7991"
      "tls://avevad.com:1337"
    ];
  };
}
