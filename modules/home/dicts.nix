{ pkgs, ... }:

{
  home.packages = with pkgs.hunspellDicts; [
    de-de
    en-gb-large
    en-us-large
    es-es
    it-it
    pl-pl
    ru-ru
  ];
}
