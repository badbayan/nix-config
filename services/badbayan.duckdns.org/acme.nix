{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "badya65@gmail.com";
      group = "acme";
    };
    certs = {
      ${config.networking.domain} = {
        domain = "*." + config.networking.domain;
        extraDomainNames = [ config.networking.domain ];
        dnsProvider = "duckdns";
        credentialsFile = "/root/secrets/acme/duckdns.env";
        dnsPropagationCheck = true;
        group = config.security.acme.defaults.group;
      };
    };
  };
}
