let
  disabled = import ./disabledapp.nix;

  columns = 80;
  lines = 24;
  pad = 10;
  term = "xterm-256color";
  fontsize = 11;
  scrollback = 10000;

  colors = {
    background = "080808";
    foreground = "b2b2b2";

    normal = {
      black = "323437";
      red = "ff5454";
      green = "8cc85f";
      yellow = "e3c78a";
      blue = "80a0ff";
      magenta = "d183e8";
      cyan = "79dac8";
      white = "c6c6c6";
    };

    bright = {
      black = "949494";
      red = "ff5189";
      green = "36c692";
      yellow = "c2c292";
      blue = "74b2ff";
      magenta = "ae81ff";
      cyan = "85dc85";
      white = "e4e4e4";
    };
  };
in {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        env.TERM = term;
        font = {
          size = fontsize;
          offset.x = 1;
        };
        window = {
          dimensions = {
            columns = columns;
            lines = lines;
          };
          padding = {
            x = pad;
            y = pad;
          };
          decorations_theme_variant = "Dark";
        };
        scrolling.history = scrollback;
        colors = {
          primary = {
            background = "#${colors.background}";
            foreground = "#${colors.foreground}";
          };
          normal = {
            black = "#${colors.normal.black}";
            red = "#${colors.normal.red}";
            green = "#${colors.normal.green}";
            yellow = "#${colors.normal.yellow}";
            blue = "#${colors.normal.blue}";
            magenta = "#${colors.normal.magenta}";
            cyan = "#${colors.normal.cyan}";
            white = "#${colors.normal.white}";
          };
          bright = {
            black = "#${colors.bright.black}";
            red = "#${colors.bright.red}";
            green = "#${colors.bright.green}";
            yellow = "#${colors.bright.yellow}";
            blue = "#${colors.bright.blue}";
            magenta = "#${colors.bright.magenta}";
            cyan = "#${colors.bright.cyan}";
            white = "#${colors.bright.white}";
          };
        };
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {
          term = term;
          font = "monospace:size=" + toString fontsize;
          dpi-aware = "no";
          pad = toString pad + "x" + toString pad;
          initial-window-size-chars = toString columns + "x" + toString lines;
        };
        bell.urgent = "yes";
        scrollback.lines = scrollback;
        csd = {
          border-color = "ff3e3e3e";
          border-width = 2;
          button-color = "ffffffff";
          color = "ff303030";
          hide-when-maximized = "yes";
        };
        key-bindings = {
          scrollback-up-page = "Shift+Page_Up Shift+KP_Page_Up";
          scrollback-down-page = "Shift+Page_Down Shift+KP_Page_Down";
          scrollback-home = "Shift+Home Shift+KP_Home";
          scrollback-end = "Shift+End Shift+KP_End";
        };
        colors = {
          background = colors.background;
          foreground = colors.foreground;
          regular0 = colors.normal.black;
          regular1 = colors.normal.red;
          regular2 = colors.normal.green;
          regular3 = colors.normal.yellow;
          regular4 = colors.normal.blue;
          regular5 = colors.normal.magenta;
          regular6 = colors.normal.cyan;
          regular7 = colors.normal.white;
          bright0 = colors.bright.black;
          bright1 = colors.bright.red;
          bright2 = colors.bright.green;
          bright3 = colors.bright.yellow;
          bright4 = colors.bright.blue;
          bright5 = colors.bright.magenta;
          bright6 = colors.bright.cyan;
          bright7 = colors.bright.white;
        };
      };
    };
  };
  xdg.desktopEntries = {
    foot = {
      categories = [ "System" "TerminalEmulator" ];
      comment = "A wayland native terminal emulator";
      exec = "foot -d warning";
      genericName = "Terminal";
      icon = "foot";
      name = "Foot";
      terminal = false;
      type = "Application";
    };
    "org.codeberg.dnkl.foot" = disabled;
    "org.codeberg.dnkl.foot-server" = disabled;
    "org.codeberg.dnkl.footclient" = disabled;
  };
}
