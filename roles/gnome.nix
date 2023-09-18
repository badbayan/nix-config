{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.roles.gnome;
in {
  options.roles.gnome.enable = mkOption {
    default = false;
    type = types.bool;
  };

  config = mkIf cfg.enable {
    roles.desktop.enable = mkForce true;

    nixpkgs.overlays = [(self: super: {
      gnome = super.gnome.overrideScope' (gself: gsuper: {
        # gnome-session = gsuper.gnome-session.overrideAttrs (old: {
        #   passthru.providedSessions =
        #     old.passthru.providedSessions ++ [ "gnome-wayland" ];
        # });
        nautilus = gsuper.nautilus.overrideAttrs (old: with pkgs; {
          preFixup = old.preFixup + ''
            gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${gnome.totem}/share")
          '';
        });
      });
    })];

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
        # gnome-text-editor
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        baobab
        # cheese
        epiphany
        evince
        evolution-data-server
        # geary
        gnome-contacts
        gnome-font-viewer
        gnome-maps
        gnome-music
        gnome-software
        rygel
        # seahorse
        simple-scan
        totem
        yelp
      ]);
    };
  };
}
