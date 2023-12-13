{ config, pkgs, ... }:
let
  user = "taisa";
  username = "Taisa";
in {
  users.users.${user} = {
    description = username;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    initialPassword = user;
    isNormalUser = true;
  };

  home-manager.users.${user} = { lib, ... }: {
    dconf.settings = lib.mkIf (config.roles.desktop == "gnome") {
      "org/gnome/desktop/input-sources" = {
        sources = lib.mkForce [
          (lib.hm.gvariant.mkTuple [ "xkb" "ru" ])
          (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        ];
        xkb-options = lib.mkForce [
          "ctrl:nocaps"
          "lv3:ralt_switch_multikey"
          "misc:typo"
        ];
      };
    };

    home.packages = lib.mkIf (config.roles.desktop != null) (with pkgs; [
      google-chrome
      telegram-desktop
    ]);
  };
}
