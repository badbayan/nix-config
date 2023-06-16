let
  disabled = import ./disabledapp.nix;
in {
  xdg = {
    desktopEntries = {
      nixos-manual = disabled;
      umpv = disabled;
      winetricks = disabled;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
