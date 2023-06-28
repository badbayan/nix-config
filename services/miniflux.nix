{ config, lib, ... }:
with lib;
let
  cfg = config.roles.server.miniflux;
in {
  options.roles.server.miniflux = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    domain = mkOption {
      default = config.roles.server.domain;
      type = types.str;
    };
    adminCredentialsFile = mkOption {
      default = "${pkgs.writeText "minifluxPass" "pass"}";
      type = types.str;
    };
    pollingFrequency = mkOption {
      default = "30";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    roles.server.nginx.enable = mkForce true;

    systemd.services.miniflux = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      serviceConfig.RuntimeDirectoryMode = lib.mkForce "0755";
    };

    services = {
      postgresql = {
        enable = mkForce true;
        ensureDatabases = [ "miniflux" ];
        ensureUsers = [{
          name = "miniflux";
          ensurePermissions = { "DATABASE miniflux" = "ALL PRIVILEGES"; };
        }];
      };

      miniflux = {
        enable = true;
        adminCredentialsFile = cfg.adminCredentialsFile;
        config = {
          LISTEN_ADDR = "/run/miniflux/miniflux.sock";
          RUN_MIGRATIONS = "1";
          POLLING_FREQUENCY = cfg.pollingFrequency;
          BASE_URL = "https://rss." + cfg.domain;
        };
      };

      nginx = {
        upstreams.miniflux.servers = { "unix:${config.services.miniflux.config.LISTEN_ADDR}" = {}; };
        virtualHosts."rss.${cfg.domain}" = {
          forceSSL = true;
          useACMEHost = cfg.domain;
          locations."/".proxyPass = "http://miniflux";
        };
      };
    };
  };
}
