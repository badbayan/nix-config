{ lib, ... }:
with lib;
{
  services.yggdrasil = {
    persistentKeys = mkDefault true;
    settings.Peers = mkDefault [
      "tls://s-ovb-0.sergeysedoy97.ru:65535"
      "tls://s-ovb-1.sergeysedoy97.ru:65535"
      "tls://srv.itrus.su:7992"
      "tls://ekb.itrus.su:7992"
    ];
  };
}
