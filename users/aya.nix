{ config, pkgs, inputs, ... }:

{
  users.users.aya = {
    isNormalUser = true;
    description = "badbayan";
    extraGroups = [ "wheel" "audio" "video" "kvm" "libvirtd" "adbusers" ];
    createHome = true;
    homeMode = "711";
  };

  home-manager.users.aya = {
    imports = with inputs.self.home; [
      chromium
      dconf
      git
      gtk
      mpv
      obs
      terminals
      xdg
      xresources
      zathura
    ];

    fonts.fontconfig.enable = false;

    home = {
      stateVersion = config.system.stateVersion;

      packages = with pkgs; [
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
