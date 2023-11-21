{ config, lib, pkgs, inputs, ... }:
let
  email = "badya65@gmail.com";
  user = "aya";
  username = "badbayan";
in {
  users.users.${user} = {
    description = username;
    extraGroups = [ "wheel" "audio" "video" "kvm" "libvirtd" "networkmanager" "adbusers" ];
    initialPassword = user;
    isNormalUser = true;
  };

  documentation.man.generateCaches = true;
  environment.gnome.excludePackages = with pkgs; [ gnome-text-editor ];

  home-manager.users.${user} = {
    imports = with inputs.self.home; lib.optionals (config.roles.desktop != null) [
      dicts
      emacs
      obs
    ];

    programs.git = {
      userEmail = email;
      userName = username;
    };

    dconf.settings = lib.mkIf (config.roles.desktop == "gnome") {
      "org/gnome/shell" = {
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "allowlockedremotedesktop@kamens.us"
          "BingWallpaper@ineffable-gmail.com"
          "caffeine@patapon.info"
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

    home.packages = lib.mkIf (config.roles.desktop != null) (with pkgs; [
      element-desktop
      gimp
      google-chrome
    ]);
  };
}
