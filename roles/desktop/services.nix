{ lib, ... }:

{
  services = {
    logind.killUserProcesses = true;
    dbus = {
      enable = true;
      implementation = "broker";
    };
    flatpak.enable = true;
    gnome = {
      at-spi2-core.enable = lib.mkForce false;
      evolution-data-server.enable = lib.mkForce false;
      gnome-keyring.enable = lib.mkForce false;
      rygel.enable = lib.mkForce false;
      tracker-miners.enable = lib.mkForce false;
      tracker.enable = lib.mkForce false;
    };
    gvfs.enable = true;
  };
}
