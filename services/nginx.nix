{ config, lib, ... }:
with lib;
let
  cfg = config.roles.server.nginx;
in {
  options.roles.server.nginx.enable = mkOption {
    default = false;
    type = types.bool;
  };

  config = mkIf cfg.enable {
    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };
}
