{ config, lib, pkgs, ... }:
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

    services.nginx = {
      enable = true;
      additionalModules = with pkgs.nginxModules; [ dav fancyindex ];
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };
}
