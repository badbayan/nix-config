{
  boot.kernelModules = [ "netatop" ];

  programs.atop = {
    enable = true;
    netatop.enable = true;
    setuidWrapper.enable = true;
  };
}
