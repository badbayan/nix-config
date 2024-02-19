{ config, lib, pkgs, ... }:
with lib;
{
  config = mkIf (config.roles.desktop == "gnome") {
    services.xserver = {
      desktopManager.gnome = {
        enable = true;
        sessionPath = (with pkgs; [
          adw-gtk3
        ]) ++ (with pkgs.gnomeExtensions; [
          allow-locked-remote-desktop
          alphabetical-app-grid
          arcmenu
          bing-wallpaper-changer
          caffeine
          dash-to-panel
          overview-background
        ]);
      };
      displayManager = {
        defaultSession = "gnome";
        gdm = {
          enable = true;
          autoSuspend = false;
          wayland = true;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    environment.gnome.excludePackages = (with pkgs; [
      at-spi2-atk
      at-spi2-core
      gnome-connections
      gnome-console
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      baobab
      epiphany
      evince
      evolution-data-server
      gnome-contacts
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-software
      rygel
      simple-scan
      totem
      yelp
    ]);
  };
}
