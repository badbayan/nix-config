let
  gtksettings = {
    gtk-application-prefer-dark-theme = 1;
    gtk-recent-files-max-age = 0;
  };
in {
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };

    font = {
      name = "sans";
      size = 10;
    };

    gtk3 = {
      extraCss = ''
        VteTerminal, vte-terminal {
            padding: 10px;
        }
      '';
      extraConfig = gtksettings;
    };

    gtk4 = {
      extraConfig = gtksettings;
    };

    iconTheme.name = "Papirus-Dark";

    theme.name = "adw-gtk3";
  };
}
