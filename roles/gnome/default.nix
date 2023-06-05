{ lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [ roles.desktop ];

  programs = {
    gnupg.agent.pinentryFlavor = "gnome3";
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
        sessionPath = (with pkgs; [
          adw-gtk3
        ]) ++ (with pkgs.gnomeExtensions; [
          alphabetical-app-grid
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
  };

  environment = {
    sessionVariables = {
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Adwaita";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment = {
    gnome.excludePackages = (with pkgs; [
      at-spi2-atk
      at-spi2-core
      gnome-connections
      gnome-console
      gnome-photos
      gnome-text-editor
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      baobab
      cheese
      epiphany
      evince
      evolution-data-server
      geary
      gnome-contacts
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-software
      rygel
      #seahorse
      simple-scan
      totem
      yelp
    ]);
  };
}
