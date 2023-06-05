{ lib, pkgs, ... }:

{
  services = {
    logind.killUserProcesses = true;
    dbus = {
      enable = true;
      implementation = "broker";
    };
    flatpak.enable = true;
    gnome = {
      at-spi2-core.enable = lib.mkForce false;
      evolution-data-server.enable = lib.mkForce false;
      gnome-initial-setup.enable = lib.mkForce false;
      #gnome-keyring.enable = lib.mkForce false;
      rygel.enable = lib.mkForce false;
      tracker-miners.enable = lib.mkForce false;
      tracker.enable = lib.mkForce false;
    };
    gvfs.enable = true;
    xserver = {
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
      layout = "us,ru";
      xkbOptions = "ctrl:nocaps,grp:alts_toggle,grp_led:caps,misc:typo,srvrkeys:none";
      xkbVariant = "";
      libinput.enable = true;
      excludePackages = with pkgs; [ xterm ];
    };
  };

  virtualisation = {
    containers.enable = true;
    libvirtd.enable = true;
  };
}
