{ pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      iosevka-bin
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-extra
      open-sans
      vollkorn
    ];
    fontconfig = {
      enable = true;
      allowBitmaps = false;
      antialias = true;
      cache32Bit = true;
      includeUserConf = true;
      defaultFonts = {
        monospace = [ "Iosevka Term" "Source Code Pro" ];
        sansSerif = [ "Open Sans" "Noto Sans" ];
        serif = [ "Vollkorn" "Noto Serif" ];
      };
      hinting = {
        enable = true;
        autohint = false;
        style = "hintfull";
      };
      subpixel = {
        lcdfilter = "none";
        rgba = "none";
      };
    };
  };
}
