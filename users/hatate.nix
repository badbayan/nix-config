{ config, pkgs, inputs, ... }:
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

    fonts.fontconfig.enable = false;

    home = {
      inherit (config.system) stateVersion;

      packages = with pkgs; [
        telegram-desktop
      ];
    };
  };
}
