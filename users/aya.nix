{ config, pkgs, inputs, ... }:
let
  user = "aya";
in {
  users.users.${user} = {
    description = "badbayan";
    extraGroups = [ "wheel" "audio" "video" "kvm" "libvirtd" "networkmanager" "adbusers" ];
    homeMode = "711";
    initialPassword = user;
    isNormalUser = true;
  };

  home-manager.users.${user} = {
    imports = with inputs.self.home; [
      chromium
      dconf
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

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "allowlockedremotedesktop@kamens.us"
          "caffeine@patapon.info"
          #"gsconnect@andyholmes.github.io"
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
        crawlTiles
        element-desktop.desktopItem
        element-desktop-wayland
        google-chrome
        gimp
        gzdoom
        legendary-gl
        mame
        mednafen
        mednaffe
        wineWowPackages.waylandFull
        winetricks
      ];
    };
  };
}
