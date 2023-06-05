{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Peers = [
        "tcp://itcom.multed.com:7991"
        "tcp://srv.itrus.su:7991"
        "tls://avevad.com:1337"
      ];
    };
  };
}
