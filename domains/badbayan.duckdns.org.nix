{ config, pkgs, inputs, ... }:
let
  dns = "duckdns";
  domain = "badbayan.duckdns.org";
  email = "badya65@gmail.com";
  homepage.root = "/system/data/homepage";
  public = {
    alias = "/system/data/pub/";
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
    inherit domain;
    miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux.path;
    };
    nginx.enable = true;
    # nextcloud = {
    #   enable = true;
    #   adminpassFile = config.age.secrets.nextcloud.path;
    # };
    # prosody = {
    #   enable = true;
    #   admins = [ "badbayan@${domain}" ];
    # };
    # vaultwarden.enable = true;
  };

  age.secrets = with inputs.self.modules; {
    ${dns}.file = secrets.${dns};
    miniflux.file = secrets.miniflux;
    # nextcloud = {
    #   file = secrets.nextcloud;
    #   group = "nextcloud";
    #   owner = "nextcloud";
    # };
    nix-serve.file = secrets.nix-serve;
  };

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve;
    secretKeyFile = config.age.secrets.nix-serve.path;
  };

  security.acme.certs.${domain} = {
    credentialsFile = config.age.secrets.${dns}.path;
    domain = "*." + domain;
    dnsPropagationCheck = true;
    dnsProvider = dns;
    inherit email;
    extraDomainNames = [ domain ];
    inherit (config.security.acme.defaults) group;
  };

  services.nginx.virtualHosts = {
    ${domain} = {
      serverName = domain;
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      locations."/" = homepage;
      locations."/pub/" = public;
    };

    "nix.${domain}" = {
      serverName = "nix." + domain;
      forceSSL = true;
      useACMEHost = domain;
      locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
    };

    "*.${domain}" = {
      default = true;
      serverName = "*." + domain;
      forceSSL = true;
      useACMEHost = domain;
      globalRedirect = domain;
    };

    ${ygg.domain} = {
      inherit (ygg) listen;
      serverName = ygg.domain;
      addSSL = false;
      locations."/" = homepage;
      locations."/pub/" = public;
    };
  };
}
