{ config, ... }:

{
  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    #upstreams.dendrite.servers = { "127.0.0.1:8008" = {}; };
    virtualHosts = {
      ${config.networking.domain} = { # Homepage
        serverName = config.networking.domain;
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".root = "/home/aya/org/homepage";
        locations."/pub/" = {
          alias = "/home/aya/Public/";
          extraConfig = ''
            autoindex on;
            autoindex_exact_size on;
            directio 4M;
          '';
        };
        #locations."/.well-known/matrix/server" = {
        #  return = "200 '{ \"m.server\": \"matrix.${config.networking.domain}:443\" }'";
        #};
        #locations."/.well-known/matrix/client" = {
        #  extraConfig = "add_header Access-Control-Allow-Origin '*';";
        #  return = "200 '{ \"m.homeserver\": { \"base_url\": \"https://matrix.${config.networking.domain}\" } }'";
        #};
        #locations."/_matrix".proxyPass = "http://dendrite";
      };

      "*.${config.networking.domain}" = { # Wildcard
        default = true;
        serverName = "*." + config.networking.domain;
        forceSSL = true;
        useACMEHost = config.networking.domain;
        globalRedirect = config.networking.domain;
      };

      "badbayan.ygg" = { # Yggdrasil
        listen = [
          { addr = "[204:7039:ade1:9854:d9a7:3f43:3996:b4cc]"; }
          { addr = "[304:7039:ade1:9854::bad]"; }
        ];
        addSSL = false;
        serverName = "badbayan.ygg";
        locations."/".root = "/home/aya/org/homepage";
        locations."/pub/" = {
          alias = "/home/aya/Public/";
          extraConfig = ''
            autoindex on;
            autoindex_exact_size on;
            directio 4M;
          '';
        };
      };
    };
  };
}
