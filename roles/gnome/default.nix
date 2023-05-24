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
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
      layout = "us,ru";
      libinput.enable = true;
      xkbOptions = "ctrl:nocaps,grp:alts_toggle,grp_led:caps,misc:typo,srvrkeys:none";
      xkbVariant = "";
      excludePackages = with pkgs; [ xterm ];
      desktopManager.gnome.enable = true;
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

  qt5 = {
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
      eog
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
      seahorse
      simple-scan
      totem
      yelp
    ]);
  };
}
