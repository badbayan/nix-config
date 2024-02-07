{
  environment.shellAliases = {
    ls = "ls --color=auto";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
    ee = "emacsclient -nw -c -q -u -a 'emacs -nw'";
    tmux = "systemd-run --user --scope --setenv=SHLVL=0 tmux";
  };
}
