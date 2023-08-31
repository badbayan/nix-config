{ config, pkgs, inputs, ... }:
let
  email = "badya65@gmail.com";
  user = "aya";
  username = "badbayan";
in {
  users.users.${user} = {
    description = username;
    extraGroups = [ "wheel" "audio" "video" "kvm" "libvirtd" "networkmanager" "adbusers" ];
    homeMode = "711";
    initialPassword = user;
    isNormalUser = true;
  };

  environment.gnome.excludePackages = with pkgs; [ gnome-text-editor ];

  home-manager.users.${user} = {
    imports = with inputs.self.home; [
      chromium
      dconf
      dicts
      emacs
      git
      gtk
      mpv
      obs
      terminals
      xdg
      xresources
      zathura
    ];

    programs.git = {
      userEmail = email;
      userName = username;
    };

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "allowlockedremotedesktop@kamens.us"
          "BingWallpaper@ineffable-gmail.com"
          "caffeine@patapon.info"
          #"gsconnect@andyholmes.github.io"
          "overviewbackground@github.com.orbitcorrection"
        ];
        favorite-apps = [
          "google-chrome.desktop"
          "element-desktop.desktop"
          "foot.desktop"
          "emacs.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
      "org/gnome/shell/extensions/bingwallpaper" = {
        set-background = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gtk/settings/file-chooser" = {
        show-hidden = true;
      };
    };

    fonts.fontconfig.enable = false;

    home = {
      stateVersion = config.system.stateVersion;

      packages = with pkgs; [
        element-desktop
        google-chrome
        gimp
      ];
    };
  };
}
