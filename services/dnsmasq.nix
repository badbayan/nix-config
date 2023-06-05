{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    resolveLocalQueries = true;
    settings = {
      all-servers = true;
      bogus-priv = true;
      cache-size = 1500;
      domain-needed = true;
      no-negcache = true;
      no-poll = true;
      server = [
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
