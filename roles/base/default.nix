{ config, pkgs, ... }:

let
  find = "fd -calways -uE'.git' --strip-cwd-prefix";
in
{
  imports = [
    ./nix.nix
    ./console.nix
    ./zsh.nix
  ];

  system.stateVersion = "23.05";

  environment = {
    localBinInPath = true;

    sessionVariables = {
      EDITOR = "vi";
      FZF_DEFAULT_COMMAND = find + " -tf";
      FZF_ALT_C_COMMAND = find + " -td";
      FZF_CTRL_T_COMMAND = find + " -tf";
      FZF_DEFAULT_OPTS = "--ansi";
    };

    systemPackages = with pkgs; [
      _7zz
      binutils
      curl
      dig
      direnv
      fd
      file
      fzf
      git
      lsof
      ncdu
      nmap
      nvi
      #p7zip
      pinentry-curses
      (procps.overrideAttrs (attrs: {
        meta.priority = pkgs.coreutils.meta.priority + 1;
      }))
      pwgen
      ripgrep
      translate-shell
      unrar
      unzip
      vim
      zip
    ];
  };
}
