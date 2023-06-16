{ pkgs, ... }:

{
  #environment.sessionVariables.FREETYPE_PROPERTIES = ''
  #  autofitter:no-stem-darkening=0
  #  autofitter:darkening-parameters=500,200,1000,100,1667,100,2333,0
  #'';

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
        style = "hintslight";
      };
      subpixel = {
        lcdfilter = "none";
        rgba = "none";
      };
    };
  };
}
