{ config, lib, ... }:
let
  dns = "duckdns";
  domain = "badbayan.duckdns.org";
  email = "badya65@gmail.com";
  homepage.root = "/home/aya/org/homepage";
  public = {
    alias = "/home/aya/Public/";
    extraConfig = ''
      fancyindex on;
      fancyindex_exact_size on;
      directio 4M;
    '';
  };
  ygg = {
    domain = "badbayan.ygg";
    listen = [
      { addr = "[204:7039:ade1:9854:d9a7:3f43:3996:b4cc]"; }
      { addr = "[304:7039:ade1:9854::bad]"; }
    ];
  };
in {
  roles.server = {
    domain = domain;
    miniflux = {
      enable = true;
      adminCredentialsFile = "/root/secrets/miniflux.env";
    };
    nginx.enable = true;
    #nextcloud.enable = true;
    #prosody = {
    #  enable = true;
    #  admins = [ "badbayan@${domain}" ];
    #};
    #vaultwarden.enable = true;
  };

  security.acme.certs.${domain} = {
    credentialsFile = "/root/secrets/acme/${dns}.env";
    domain = "*." + domain;
    dnsPropagationCheck = true;
    dnsProvider = dns;
    email = email;
    extraDomainNames = [ domain ];
    group = config.security.acme.defaults.group;
  };

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  services.nginx.virtualHosts = {
    ${domain} = {
      serverName = domain;
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      locations."/" = homepage;
      locations."/pub/" = public;
    };

    "*.${domain}" = {
      default = true;
      serverName = "*." + domain;
      forceSSL = true;
      useACMEHost = domain;
      globalRedirect = domain;
    };

    ${ygg.domain} = {
      listen = ygg.listen;
      serverName = ygg.domain;
      addSSL = false;
      locations."/" = homepage;
      locations."/pub/" = public;
    };
  };
}
