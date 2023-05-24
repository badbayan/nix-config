{ ... }:

{
  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 80 443 8448 ];

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      upstreams = {
        "dendrite".servers = { "127.0.0.1:8008" = {}; };
        "miniflux".servers = { "unix:/run/miniflux/miniflux.sock" = {}; };
      };

      virtualHosts = {
        "badbayan.duckdns.org" = { # Homepage
          serverName = "badbayan.duckdns.org";
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations."/".root = "/home/aya/Public/org-home";
          locations."/share/" = {
            alias = "/home/aya/Public/share/";
            extraConfig = ''
              autoindex on;
              autoindex_exact_size on;
              directio 4M;
            '';
          };
          locations."/.well-known/matrix/server" = {
            return = "200 '{ \"m.server\": \"matrix.badbayan.duckdns.org:443\" }'";
          };
          locations."/.well-known/matrix/client" = {
            extraConfig = "add_header Access-Control-Allow-Origin '*';";
            return = "200 '{ \"m.homeserver\": { \"base_url\": \"https://matrix.badbayan.duckdns.org\" } }'";
          };
          locations."/_matrix".proxyPass = "http://dendrite";
        };

        "rss.badbayan.duckdns.org" = { # Miniflux
          forceSSL = true;
          useACMEHost = "badbayan.duckdns.org";
          locations."/".proxyPass = "http://miniflux";
        };

        "*.badbayan.duckdns.org" = { # Wildcard
          default = true;
          serverName = "*.badbayan.duckdns.org";
          forceSSL = true;
          useACMEHost = "badbayan.duckdns.org";
          globalRedirect = "badbayan.duckdns.org";
        };

        "badbayan.ygg" = { # Yggdrasil
          listen = [
            { addr = "[204:7039:ade1:9854:d9a7:3f43:3996:b4cc]"; }
            { addr = "[304:7039:ade1:9854::bad]"; }
          ];
          addSSL = false;
          serverName = "badbayan.ygg";
          locations."/".root = "/home/aya/Public/org-home";
          locations."/share/" = {
            alias = "/home/aya/Public/share/";
            extraConfig = ''
              autoindex on;
              autoindex_exact_size on;
              directio 4M;
            '';
          };
        };
      };
    };
  };
}
