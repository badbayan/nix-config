{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.roles.desktop;
in {
  options.roles.desktop.enable = mkOption {
    default = false;
    type = types.bool;
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        package = pkgs.bluezFull;
      };
      pulseaudio.enable = false;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
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
        #gnome-keyring.enable = mkForce false;
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
        autoRepeatDelay = 300;
        autoRepeatInterval = 20;
        layout = "us,ru";
        xkbOptions = "ctrl:nocaps,grp:alts_toggle,grp_led:caps,misc:typo,srvrkeys:none";
        xkbVariant = "";
        libinput.enable = true;
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
        #FREETYPE_PROPERTIES = mkDefault ''
        #  autofitter:no-stem-darkening=0
        #  autofitter:darkening-parameters=500,200,1000,100,1667,100,2333,0
        #'';
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
        gnome.gnome-disk-utility
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
        xdg-user-dirs
        xdg-utils
        xsettingsd
        (writeShellScriptBin "xterm" ''
          if [ "$XDG_SESSION_TYPE" = wayland ]; then
              exec foot -d warning -a "''${TERMCLASS:-foot}" "$@"
          else
              exec alacritty --class "''${TERMCLASS:-Alacritty},Alacritty" "$@"
          fi
        '')
        yt-dlp
        zathura
      ];
    };

    fonts = {
      enableDefaultFonts = true;
      fontDir.enable = true;
      fonts = with pkgs; [
        (iosevka-bin.override {
          variant = "curly";
        })
        liberation_ttf
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        noto-fonts-extra
        open-sans
        vollkorn
      ];
      fontconfig = {
        enable = true;
        allowBitmaps = false;
        antialias = true;
        cache32Bit = true;
        includeUserConf = true;
        defaultFonts = {
          monospace = [ "Iosevka Term Curly" ];
          sansSerif = [ "Open Sans" "Noto Sans" ];
          serif = [ "Vollkorn" "Noto Serif" ];
        };
        hinting = {
          enable = true;
          autohint = false;
          style = "hintslight";
        };
        subpixel = {
          lcdfilter = "none";
          rgba = "none";
        };
      };
    };
  };
}
