{ pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    roles.base

    ./hardware.nix
    ./fonts.nix
    ./services.nix
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
    glib
    gnome.adwaita-icon-theme
    gnome.dconf-editor
    gnome.gnome-disk-utility
    gsettings-desktop-schemas
    helvum
    imv
    libnotify
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
    virt-manager
    vulkan-tools
    xdg-user-dirs
    xdg-utils
    xsettingsd
    yt-dlp
    zathura
  ];
}
