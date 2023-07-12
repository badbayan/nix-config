{ config, pkgs, inputs, ... }:
let
  user = "hatate";
in {
  users.users.${user} = {
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    initialPassword = user;
    isNormalUser = true;
  };

  home-manager.users.${user} = {
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

    fonts.fontconfig.enable = false;

    home = {
      stateVersion = config.system.stateVersion;

      packages = with pkgs; [
        telegram-desktop
      ];
    };
  };
}
