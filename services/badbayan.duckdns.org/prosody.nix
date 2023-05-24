{ ... }:

{
  users.users.prosody.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 5222 5269 ];

  services = {
    prosody = {
      enable = true;
      admins = [ "badbayan@badbayan.duckdns.org" ];
      ssl.cert = "/var/lib/acme/badbayan.duckdns.org/fullchain.pem";
      ssl.key = "/var/lib/acme/badbayan.duckdns.org/key.pem";
      virtualHosts."badbayan.duckdns.org" = {
        enabled = true;
        domain = "badbayan.duckdns.org";
        ssl.cert = config.services.prosody.ssl.cert;
        ssl.key = config.services.prosody.ssl.key;
      };
      muc = [{
        domain = "conf.badbayan.duckdns.org";
      }];
      uploadHttp = {
        domain = "upload.badbayan.duckdns.org";
      };
    };
  };
}
