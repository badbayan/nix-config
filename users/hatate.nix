{ config, pkgs, ... }:
let
  user = "hatate";
  username = "Taisa";
in {
  users.users.${user} = {
    description = username;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    initialPassword = user;
    isNormalUser = true;
  };

  home-manager.users.${user} = { lib, ... }: {
    dconf.settings = lib.mkIf config.roles.gnome.enable {
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

    home.packages = lib.mkIf config.roles.desktop.enable (with pkgs; [
      telegram-desktop
    ]);
  };
}
