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
        safe.directory = "/etc/nixos";
        status.showUntrackedFiles = "normal";
      };
    }];
    userEmail = "badya65@gmail.com";
    userName = "badbayan";
  };
}
