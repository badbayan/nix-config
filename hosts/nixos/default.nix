{ config, lib, inputs, ... }:

{
  documentation.doc.enable = false;
  documentation.nixos.enable = false;

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

  home-manager.users.nixos = lib.mkIf config.roles.gnome.enable {
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
