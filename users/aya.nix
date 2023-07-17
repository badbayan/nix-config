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

  environment.gnome.excludePackages = with pkgs; [ gnome-text-editor ];

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
        deluge
        easyeffects
        element-desktop.desktopItem
        element-desktop-wayland
        google-chrome
        gimp
        gzdoom
        legendary-gl
        mednafen
        mednaffe
        wineWowPackages.waylandFull
        winetricks
      ];
    };
  };
}
