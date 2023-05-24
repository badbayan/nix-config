{ ... }:

{
  services = {
    dnsmasq = {
      enable = true;
      alwaysKeepRunning = true;
      extraConfig = ''
        domain-needed
        bogus-priv
        no-poll
        no-negcache
        cache-size=1500
        all-servers
      '';
      resolveLocalQueries = true;
      servers = [
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
