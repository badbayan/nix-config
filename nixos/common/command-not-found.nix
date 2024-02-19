{ config, ... }:

{
  programs-sqlite.enable = config.programs.command-not-found.enable;
}
