{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [ "xkb" "us" ])
        (mkTuple [ "xkb" "ru" ])
      ];
      xkb-options = [
        "ctrl:nocaps"
        "grp_led:caps"
        "lv3:ralt_switch_multikey"
        "misc:typo"
      ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Adwaita";
      document-font-name = "serif 10";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "sans 10";
      gtk-theme = "adw-gtk3";
      icon-theme = "Papirus-Dark";
      monospace-font-name = "monospace 11";
    };

    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };

    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 300;
      repeat-interval = mkUint32 20;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = true;
      speed = 0.25;
    };
    "org/gnome/desktop/peripherals/trackball" = {
      accel-profile = "adaptive";
      middle-click-emulation = true;
      scroll-wheel-emulation-button = 3;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 3;
      recent-files-max-age = -1;
      remember-app-usage = false;
      remember-recent-files = false;
      remove-old-trash-files = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      cycle-group = [ "<Alt>Above_Tab" ];
      cycle-group-backward = [ "<Shift><Alt>Above_Tab" ];
      minimize = [];
      move-to-workspace-1 = [ "<Shift><Super>q" ];
      move-to-workspace-2 = [ "<Shift><Super>w" ];
      move-to-workspace-3 = [ "<Shift><Super>e" ];
      move-to-workspace-4 = [ "<Shift><Super>r" ];
      move-to-workspace-last = [ "<Shift><Super>d" ];
      move-to-workspace-left = [ "<Shift><Super>h" ];
      move-to-workspace-right = [ "<Shift><Super>l" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-group = [ "<Super>Above_Tab" ];
      switch-group-backward = [ "<Shift><Super>Above_Tab" ];
      switch-to-workspace-1 = [ "<Super>q" ];
      switch-to-workspace-2 = [ "<Super>w" ];
      switch-to-workspace-3 = [ "<Super>e" ];
      switch-to-workspace-4 = [ "<Super>r" ];
      switch-to-workspace-last = [ "<Super>d" ];
      switch-to-workspace-left = [ "<Super>h" ];
      switch-to-workspace-right = [ "<Super>l" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-fullscreen = [ "<Super>f" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
      titlebar-font = "sans 10";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };
    "org/gnome/mutter/wayland/keybindings" = {
      switch-to-session-1 = [];
      switch-to-session-2 = [];
      switch-to-session-3 = [];
      switch-to-session-4 = [];
      switch-to-session-5 = [];
      switch-to-session-6 = [];
      switch-to-session-7 = [];
      switch-to-session-8 = [];
      switch-to-session-9 = [];
      switch-to-session-10 = [];
      switch-to-session-11 = [];
      switch-to-session-12 = [];
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
    };
    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 850 ];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 22.0;
      night-light-schedule-to = 8.0;
      night-light-temperature = mkUint32 4500;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      help = [];
      screensaver = [ "<Super>F1" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "foot -d warning";
      name = "Foot";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disabled-extensions = [];
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "allowlockedremotedesktop@kamens.us"
        "caffeine@patapon.info"
        #"workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "element-desktop.desktop"
        "foot.desktop"
        "emacs.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/shell/extensions/alphabetical-app-grid" = {
      folder-order-position = "start";
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = "always";
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      sort-directories-first = true;
    };

    "org/gtk/settings/file-chooser" = {
      show-hidden = true;
      sort-directories-first = true;
    };
  };
}
