{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [(new: prev: { miniflux = pkgs.unstable.miniflux; })];

  systemd = {
    services = {
      miniflux = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
        serviceConfig.RuntimeDirectoryMode = lib.mkForce "0755";
      };
    };
  };

  services = {
    miniflux = {
      enable = true;
      adminCredentialsFile = "/root/miniflux.conf";
      config = {
        LISTEN_ADDR = "/run/miniflux/miniflux.sock";
        RUN_MIGRATIONS = "1";
        POLLING_FREQUENCY = "30";
        BASE_URL = "https://rss.badbayan.duckdns.org";
      };
    };
  };
}
