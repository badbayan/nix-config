{ pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    roles.base

    ./hardware.nix
    ./fonts.nix
    ./services.nix
    ./emacs.nix
  ];

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    gnupg.agent.enable = true;
    steam.enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bubblewrap
    easyeffects
    foot
    gimp
    glib
    gnome.adwaita-icon-theme
    gnome.dconf-editor
    gnome.gnome-disk-utility
    google-chrome
    gsettings-desktop-schemas
    helvum
    imv
    legendary-gl
    libnotify
    mednafen
    mednaffe
    mesa-demos
    (mpv.override {
      scripts = [ mpvScripts.mpris ];
    })
    (papirus-icon-theme.override {
      color = "indigo";
    })
    pavucontrol
    pinentry-gnome
    playerctl
    podman
    polkit_gnome
    qemu
    ungoogled-chromium
    virt-manager
    vulkan-tools
    wineWowPackages.waylandFull
    winetricks
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [ obs-vkcapture ];
    })
    xdg-user-dirs
    xdg-utils
    xsettingsd
    zathura
  ];
}
