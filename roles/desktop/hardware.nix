{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
