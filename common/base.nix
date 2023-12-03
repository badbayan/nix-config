{ lib, pkgs, ... }:
with lib;
let
  find = "fd -calways -uE'.git' --strip-cwd-prefix";
in {
  i18n.defaultLocale = mkDefault "ru_RU.UTF-8";
  time.timeZone = mkDefault "Asia/Novosibirsk";

  services = {
    fwupd.enable = mkDefault true;
    getty.helpLine = mkForce "";
  };

  systemd.tmpfiles.rules = [
    "w- /sys/kernel/mm/lru_gen/enabled - - - - y"
    "w- /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 1000"
  ];

  environment = {
    localBinInPath = mkDefault true;

    sessionVariables = {
      EDITOR = "vi";
      FZF_DEFAULT_COMMAND = find + " -tf";
      FZF_ALT_C_COMMAND = find + " -td";
      FZF_CTRL_T_COMMAND = find + " -tf";
      FZF_DEFAULT_OPTS = "--ansi";
      FZF_TMUX = "1";
    };

    systemPackages = with pkgs; [
      _7zz
      binutils
      btrfs-progs
      cifs-utils
      compsize
      curl
      direnv
      dnsutils
      dua
      e2fsprogs
      efibootmgr
      exfatprogs
      fd
      file
      fzf
      git
      gptfdisk
      jq
      lsof
      ncdu
      nfs-utils
      nil
      nix-diff
      nix-direnv
      nmap
      nvd
      nvi
      nvme-cli
      pciutils
      pinentry-curses
      (procps.overrideAttrs {
        meta.priority = pkgs.coreutils.meta.priority + 1;
      })
      pwgen
      ripgrep
      smartmontools
      translate-shell
      unrar
      unzip
      vim
      zip
    ];
  };
}
