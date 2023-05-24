{ ... }:

{
  services = {
    minidlna = {
      enable = true;
      openFirewall = true;
      settings = {
        inotify = "yes";
        media_dir = [
          "V,/home/aya/Videos"
          "A,/home/aya/Music"
        ];
        root_container = "B";
      };
    };
  };
}
