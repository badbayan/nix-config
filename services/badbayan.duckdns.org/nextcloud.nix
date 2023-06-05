{ config, pkgs, ... }:

{
  systemd.services.nextcloud = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services = {
    #postgresql = {
    #  ensureDatabases = [ "nextcloud" ];
    #  ensureUsers = [{
    #    name = "nextcloud";
    #    ensurePermissions = { "DATABASE nextcloud" = "ALL PRIVILEGES"; };
    #  }];
    #};

    nextcloud = {
      enable = true;
      hostName = "cloud." + config.networking.domain;
      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminpassFile = "/var/lib/nextcloud/admin.pass";
      };
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = config.networking.domain;
    };
  };
}
