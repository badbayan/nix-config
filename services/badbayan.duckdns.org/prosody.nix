{ config, ... }:

{
  users.users.prosody.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 5222 5269 ];

  services.prosody = {
    enable = true;
    admins = [ "badbayan@${config.networking.domain}" ];
    ssl.cert = "/var/lib/acme/" + config.networking.domain +"/fullchain.pem";
    ssl.key = "/var/lib/acme/" + config.networking.domain +"/key.pem";
    virtualHosts."${config.networking.domain}" = {
      enabled = true;
      domain = config.networking.domain;
      ssl.cert = config.services.prosody.ssl.cert;
      ssl.key = config.services.prosody.ssl.key;
    };
    muc = [{
      domain = "conf." + config.networking.domain;
    }];
    uploadHttp = {
      domain = "upload." + config.networking.domain;
    };
  };
}
