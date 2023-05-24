{ config, ... }:

{
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "badya65@gmail.com";
        group = "acme";
      };
      certs = {
        "badbayan.duckdns.org" = {
          domain = "*.badbayan.duckdns.org";
          extraDomainNames = [ "badbayan.duckdns.org" ];
          dnsProvider = "duckdns";
          credentialsFile = "/root/duckdns.conf";
          dnsPropagationCheck = true;
          group = config.security.acme.defaults.group;
        };
      };
    };
  };
}
