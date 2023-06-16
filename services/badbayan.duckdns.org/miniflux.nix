{ config, lib, pkgs, ... }:

{
  systemd.services.miniflux = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    serviceConfig.RuntimeDirectoryMode = lib.mkForce "0755";
  };

  services = {
    postgresql = {
      ensureDatabases = [ "miniflux" ];
      ensureUsers = [{
        name = "miniflux";
        ensurePermissions = { "DATABASE miniflux" = "ALL PRIVILEGES"; };
      }];
    };

    miniflux = {
      enable = true;
      adminCredentialsFile = "/root/secrets/miniflux.env";
      config = {
        LISTEN_ADDR = "/run/miniflux/miniflux.sock";
        RUN_MIGRATIONS = "1";
        POLLING_FREQUENCY = "30";
        BASE_URL = "https://rss." + config.networking.domain;
      };
    };

    nginx = {
      upstreams.miniflux.servers = { "unix:${config.services.miniflux.config.LISTEN_ADDR}" = {}; };
      virtualHosts."rss.${config.networking.domain}" = {
        forceSSL = true;
        useACMEHost = config.networking.domain;
        locations."/".proxyPass = "http://miniflux";
      };
    };
  };
}
