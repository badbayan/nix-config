{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
      bind-key -T prefix \\ set -g status
      bind-key -T prefix C-\; last
      set -g mouse on
      set -g renumber-windows on
      set -g set-titles on
      set -g status-left ' #h #[bg=green,fg=black] #S #[default] '
      set -g status-right ' #[bg=green,fg=black] %H:%M #[default] %a %d %b '
      set -g status-style bg=terminal,fg=terminal
      set -g window-status-format ' #I #W #F '
      set -g window-status-style bg=brightblack,fg=white
      set -g window-status-current-format ' #I #W #F '
      set -g window-status-current-style bg=cyan,fg=black
    '';
    extraConfigBeforePlugins = ''
      set -g @emulate-scroll-for-no-mouse-alternate-buffer on
    '';
    historyLimit = 10000;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
    ];
    terminal = "tmux-256color";
  };
}
