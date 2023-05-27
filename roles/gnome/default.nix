{  lib, pkgs, inputs, ... }:

{
  imports = [ ../desktop ];

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
        sessionPath = with pkgs; [
          adw-gtk3
          gnomeExtensions.alphabetical-app-grid
        ];
      };
      displayManager = {
        #autoLogin.enable = true;
        #autoLogin.user = "aya";
        defaultSession = "gnome";
        gdm = {
          enable = true;
          autoSuspend = false;
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
