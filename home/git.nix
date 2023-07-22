{
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    includes = [{
      contents = {
        advice.addIgnoredFile = false;
        commit.gpgSign = false;
        init.defaultBranch = "master";
        pull.rebase = false;
        status.showUntrackedFiles = "normal";
      };
    }];
  };
}
