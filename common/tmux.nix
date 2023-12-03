{
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    extraConfig = "set -g set-titles on";
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "tmux-256color";
  };
}
