{ config, lib, pkgs, ... }:
with lib;
let
  find = "fd -calways -uE'.git' --strip-cwd-prefix";
in {
  i18n.defaultLocale = mkDefault "ru_RU.UTF-8";
  time.timeZone = mkDefault "Asia/Novosibirsk";

  environment = {
    localBinInPath = mkDefault true;

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
      cifs-utils
      curl
      dig
      direnv
      exfatprogs
      fd
      file
      fzf
      git
      lsof
      ncdu
      nfs-utils
      nix-direnv
      nmap
      nvi
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
