{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      alang = "jpn,ja,jp,rus,ru,eng,en";
      gpu-api = "auto";
      hwdec = "auto-safe";
      osd-font = "'sans'";
      slang = "rus,ru";
      sub-file-paths = "ass:srt:sub:subs:subtitles:Ass:Srt:Sub:Subs:Subtitles:ASS:SRT:SUB:SUBS";
      sub-font = "'sans'";
      volume = 100;
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
    };
    scripts = with pkgs.mpvScripts; [
      inhibit-gnome
      mpris
      uosc
    ];
  };
}
