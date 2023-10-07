{ lib, ... }:
with lib;
{
  services.dnsmasq = {
    alwaysKeepRunning = mkDefault true;
    resolveLocalQueries = mkDefault true;
    settings = {
      all-servers = mkDefault true;
      bind-dynamic = mkDefault true;
      bogus-priv = mkDefault true;
      cache-size = mkDefault 1500;
      domain-needed = mkDefault true;
      no-negcache = mkDefault true;
      no-poll = mkDefault true;
      server = mkDefault [
        "8.8.8.8"
        "8.8.4.4"
        "1.1.1.1"
        "1.0.0.1"
        "/ygg/324:71e:281a:9ed3::53"
        "/meshname/324:71e:281a:9ed3::53"
        "/meship/324:71e:281a:9ed3::53"
        "/lib/324:71e:281a:9ed3::53"
        "/bazar/324:71e:281a:9ed3::53"
        "/emc/324:71e:281a:9ed3::53"
        "/coin/324:71e:281a:9ed3::53"
      ];
    };
  };
}
