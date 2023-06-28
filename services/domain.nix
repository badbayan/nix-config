{ config, lib, ... }:
with lib;
let
  cfg = config.roles.server.domain;
in {
  options.roles.server.domain = mkOption {
    default = config.networking.domain;
    type = types.str;
  };
}
