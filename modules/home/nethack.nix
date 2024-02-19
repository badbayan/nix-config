{ pkgs, ... }:

{
  home = {
    file.".nethackrc".text = ''
      OPTIONS=color,msg_window:full,symset:curses,time
      OPTIONS=gender:random,!legacy,number_pad:1
      OPTIONS=pickup_burden:unencumbered,pickup_types:$?!/="+
    '';
    packages = with pkgs; [ nethack ];
  };
}
