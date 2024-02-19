{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.roles.desktop;
in {
  options.roles.desktop = mkOption {
    default = null;
    type = types.nullOr (types.enum [
      "gnome" "kde"
    ]);
  };

  config = mkIf (cfg != null) {
    boot.plymouth.enable = true;

    hardware = {
      bluetooth.enable = true;
      i2c.enable = true;
      pulseaudio.enable = mkForce false;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      sensor.iio.enable = true;
    };

    programs = {
      adb.enable = true;
      dconf.enable = true;
      firejail.enable = true;
      gamemode.enable = true;
      gnupg.agent.enable = true;
      xwayland.enable = true;
    };

    security.rtkit.enable = true;

    services = {
      logind.killUserProcesses = true;
      dbus = {
        enable = true;
        implementation = "broker";
      };
      flatpak.enable = true;
      gnome = {
        at-spi2-core.enable = mkForce false;
        evolution-data-server.enable = mkForce false;
        gnome-initial-setup.enable = mkForce false;
        # gnome-keyring.enable = mkForce false;
        rygel.enable = mkForce false;
        tracker-miners.enable = mkForce false;
        tracker.enable = mkForce false;
      };
      gvfs.enable = true;
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
      xserver = {
        enable = true;
        excludePackages = with pkgs; [ xterm ];
      };
    };

    xdg = {
      autostart.enable = true;
      icons.enable = true;
      portal = {
        enable = true;
        extraPortals = mkDefault (with pkgs; [
          xdg-desktop-portal-gtk
        ]);
        xdgOpenUsePortal = true;
      };
    };

    environment = {
      sessionVariables = {
        # FREETYPE_PROPERTIES = mkDefault ''
        #   autofitter:no-stem-darkening=0
        #   autofitter:darkening-parameters=500,200,1000,100,1667,100,2333,0
        # '';
        GST_PLUGIN_SYSTEM_PATH_1_0 = makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs; [
          gst_all_1.gst-libav
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-ugly
        ]);
        NIXOS_OZONE_WL = mkDefault "1";
        QT_QPA_PLATFORM = mkDefault "wayland-egl;wayland;xcb";
        SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = mkDefault "0";
        SDL_VIDEODRIVER = mkDefault "wayland,x11";
        XCURSOR_SIZE = mkDefault "24";
        XCURSOR_THEME = mkDefault "Adwaita";
      };

      systemPackages = with pkgs; [
        alacritty
        bubblewrap
        foot
        glib
        gnome.adwaita-icon-theme
        gnome.dconf-editor
        gsettings-desktop-schemas
        helvum
        imv
        libnotify
        libva-utils
        mesa-demos
        (mpv.override {
          scripts = with mpvScripts; [
            inhibit-gnome
            mpris
            uosc
          ];
        })
        (papirus-icon-theme.override {
          color = "indigo";
        })
        pavucontrol
        pinentry-gnome
        playerctl
        polkit_gnome
        remmina
        vulkan-tools
        waypipe
        xdg-user-dirs
        xdg-utils
        xsettingsd
        xterm'
        yt-dlp
        zathura
      ];
    };

    fonts = {
      enableDefaultPackages = mkForce false;
      fontDir.enable = true;
      packages = with pkgs; [
        dejavu_fonts
        iosevka'
        freefont_ttf
        # gyre-fonts
        liberation_ttf
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        open-sans
        unifont
        vollkorn
      ];
      fontconfig = {
        enable = true;
        allowBitmaps = false;
        antialias = true;
        cache32Bit = true;
        includeUserConf = true;
        defaultFonts = {
          emoji = mkOverride 80 [ "Noto Color Emoji" ];
          monospace = mkOverride 80 [ "Iosevka Term Curly" ];
          sansSerif = mkOverride 80 [ "Open Sans" "Noto Sans" ];
          serif = mkOverride 80 [ "Vollkorn" "Noto Serif" ];
        };
        hinting = {
          enable = true;
          autohint = false;
          style = "slight";
        };
        subpixel = {
          lcdfilter = "none";
          rgba = "none";
        };
      };
    };
  };
}
