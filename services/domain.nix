{ config, lib, ... }:
with lib;
{
  options.roles.server.domain = mkOption {
    default = config.networking.domain;
    type = types.str;
  };
}
