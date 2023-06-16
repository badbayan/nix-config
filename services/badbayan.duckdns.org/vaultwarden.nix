{ config, ... }:

{
  systemd.services.vaultwarden = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services = {
    postgresql = {
      ensureDatabases = [ "vaultwarden" ];
      ensureUsers = [{
        name = "vaultwarden";
        ensurePermissions = { "DATABASE vaultwarden" = "ALL PRIVILEGES"; };
      }];
    };

    vaultwarden = {
      enable = true;
      config = {
        #ADMIN_TOKEN = "";
        DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
        DOMAIN = "https://bitwarden." + config.networking.domain;
        INVITATIONS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_LOG = "critical";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = false;
      };
      dbBackend = "postgresql";
    };

    nginx = {
      upstreams.vaultwarden.servers = { "${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}" = {}; };
      virtualHosts."bitwarden.${config.networking.domain}" = {
        forceSSL = true;
        useACMEHost = config.networking.domain;
        locations."/".proxyPass = "http://vaultwarden";
      };
    };
  };
}
