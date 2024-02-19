{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.roles.server.nextcloud;
in {
  options.roles.server.nextcloud = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    domain = mkOption {
      default = config.roles.server.domain;
      type = types.str;
    };
    adminpassFile = mkOption {
      default = "${pkgs.writeText "nextcloudPass" "pass"}";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    roles.server.nginx.enable = mkForce true;

    services = {
      postgresql = {
        enable = mkForce true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{
          name = "nextcloud";
          ensureDBOwnership = true;
        }];
      };

      nextcloud = {
        enable = true;
        hostName = "cloud." + cfg.domain;
        database.createLocally = true;
        config = {
          dbtype = "pgsql";
          inherit (cfg) adminpassFile;
        };
      };

      nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        useACMEHost = cfg.domain;
      };
    };
  };
}
