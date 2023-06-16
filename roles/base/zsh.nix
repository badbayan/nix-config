{ pkgs, ...}:

{
  environment = {
    pathsToLink = [
      "/libexec"
      "/share/zsh"
      "/share/wayland-sessions"
    ];
    shells = with pkgs; [ zsh ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs = {
    zsh = {
      enable = true;
      histFile = "~/.histfile";
      histSize = 10000;
      promptInit = "";
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_SPACE"
        "DOT_GLOB"
        "NO_HUP"
        "NO_CHECK_JOBS"
      ];
      interactiveShellInit = ''
        WORDCHARS+=$'|'
        ZLE_REMOVE_SUFFIX_CHARS=$' \t\n'
        PS1=$'%B%F{%(!.red.green)}%n@%m%f:%F{yellow}%~%f %#%b '
        stty -ixon -ixoff
        bindkey -e
        bindkey "''${terminfo[kbs]:-^?}"        backward-delete-char
        bindkey "''${terminfo[kich1]:-^[[2~}"   overwrite-mode
        bindkey "''${terminfo[kdch1]:-^[[3~}"   delete-char
        bindkey "''${terminfo[khome]:-^[OH}"    beginning-of-line
        bindkey "''${terminfo[kend]:-^[OF}"     end-of-line
        bindkey "''${terminfo[kpp]:-^[[5~}"     up-history
        bindkey "''${terminfo[knp]:-^[[6~}"     down-history
        bindkey "''${terminfo[kcuu1]:-^[[A}"    up-line-or-history
        bindkey "''${terminfo[kcud1]:-^[[B}"    down-line-or-history
        bindkey "''${terminfo[kcuf1]:-^[[C}"    forward-char
        bindkey "''${terminfo[kcub1]:-^[[D}"    backward-char
        bindkey "''${terminfo[kUP5]:-^[[1;5A}"  history-search-backward
        bindkey "''${terminfo[kDN5]:-^[[1;5B}"  history-search-forward
        bindkey "''${terminfo[kRIT5]:-^[[1;5C}" forward-word
        bindkey "''${terminfo[kLFT5]:-^[[1;5D}" backward-word
        bindkey "''${terminfo[kcbt]:-^[[Z}"     reverse-menu-complete
        if [[ -v terminfo[smkx] && -v terminfo[rmkx] ]]; then
            autoload -Uz add-zle-hook-widget
            function zle_application_mode_start { echoti smkx }
            function zle_application_mode_stop { echoti rmkx }
            add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
        fi
        zstyle ':completion:*' completer _expand _complete
        zstyle ':completion:*' menu select=2
        zstyle ':completion:*' rehash true
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
      '';
      shellInit = ''
        [[ -x "''$(command -v dircolors)" ]] && eval "''$(dircolors -b)"
        [[ -s "/etc/profiles/per-user/''${USER}/etc/profile.d/hm-session-vars.sh" ]] && \
            source "/etc/profiles/per-user/''${USER}/etc/profile.d/hm-session-vars.sh"
      '';
      shellAliases = {
        ls = "ls --color=auto";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
        ee = "emacsclient -nw -c -q -u -a 'emacs -nw'";
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
