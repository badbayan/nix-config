{ config, lib, ... }:
with lib;
let
  cfg = config.roles.server.prosody;
in {
  options.roles.server.prosody = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    admins = mkOption {
      type = types.listOf types.str;
    };
    domain = mkOption {
      default = config.roles.server.domain;
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.users.prosody.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [ 5222 5269 ];

    services.prosody = {
      enable = true;
      admins = cfg.admins;
      ssl.cert = config.security.acme.certs.${cfg.domain}.directory + "/fullchain.pem";
      ssl.key = config.security.acme.certs.${cfg.domain}.directory + "/key.pem";
      virtualHosts."${cfg.domain}" = {
        enabled = true;
        domain = cfg.domain;
        ssl.cert = config.services.prosody.ssl.cert;
        ssl.key = config.services.prosody.ssl.key;
      };
      muc = [{
        domain = "conf." + cfg.domain;
      }];
      uploadHttp = {
        domain = "upload." + cfg.domain;
      };
    };
  };
}
