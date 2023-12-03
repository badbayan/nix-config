{ config, lib, ... }:
with lib;
let
  cfg = config.roles.server.vaultwarden;
in {
  options.roles.server.vaultwarden = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    domain = mkOption {
      default = config.roles.server.domain;
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    roles.server.nginx.enable = mkForce true;

    systemd.services.vaultwarden = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };

    services = {
      postgresql = {
        enable = mkForce true;
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [{
          name = "vaultwarden";
          ensureDBOwnership = true;
        }];
      };

      vaultwarden = {
        enable = true;
        config = {
          # ADMIN_TOKEN = "";
          DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
          DOMAIN = "https://bitwarden." + cfg.domain;
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
        virtualHosts."bitwarden.${cfg.domain}" = {
          forceSSL = true;
          useACMEHost = cfg.domain;
          locations."/".proxyPass = "http://vaultwarden";
        };
      };
    };
  };
}
