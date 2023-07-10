{ config, lib, pkgs, inputs, ... }:

{
  roles.gnome.enable = true;

  documentation.doc.enable = false;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  users.users.nixos = {
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    initialPassword = "nixos";
    isNormalUser = true;
  };

  home-manager.users.nixos = {
    imports = with inputs.self.home; [
      chromium
      dconf
      git
      gtk
      mpv
      terminals
      xdg
      xresources
      zathura
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "caffeine@patapon.info"
        ];
        favorite-apps = [
          "chromium-browser.desktop"
          "org.gnome.Nautilus.desktop"
          "foot.desktop"
        ];
      };
    };

    fonts.fontconfig.enable = false;

    home.stateVersion = config.system.stateVersion;
  };
}
