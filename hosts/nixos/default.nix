{ config, lib, ... }:

{
  documentation.doc.enable = false;
  documentation.man.generateCaches = false;
  documentation.nixos.enable = false;

  boot.plymouth.enable = lib.mkForce false;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.nixos = {
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    initialHashedPassword = "";
    isNormalUser = true;
  };
  users.users.root.initialHashedPassword = "";

  home-manager.users.nixos = {
    dconf.settings = lib.mkIf config.roles.gnome.enable {
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
  };
}
