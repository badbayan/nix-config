{ config, pkgs, ... }:
let
  disabled = import ./disabledapp.nix;
  emacs = pkgs.emacs29-pgtk.override {
    withNativeCompilation = false;
    withTreeSitter = true;
  };
in {
  home.file = {
    ".emacs.d/early-init.el".source = ./emacs/early-init.el;
    ".emacs.d/init.el".source = ./emacs/init.el;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      almost-mono-themes
      circadian
      consult
      corfu
      envrc
      evil
      evil-collection
      evil-easymotion
      form-feed
      haskell-mode
      jinx
      marginalia
      markdown-mode
      meson-mode
      minions
      nix-mode
      treesit-grammars.with-all-grammars
      undo-tree
      use-package
      vertico
      yasnippet
      zig-mode
    ];
    package = emacs;
  };

  services.emacs = {
    enable = true;
    client = {
      enable = false;
      arguments = [
        "--reuse-frame"
        "--no-wait"
        "--quiet"
        "--suppress-output"
      ];
    };
    defaultEditor = true;
    package = config.programs.emacs.finalPackage;
    startWithUserSession = "graphical";
  };

  xdg.desktopEntries = {
    emacs = {
      categories = [ "Development" "TextEditor" ];
      comment = "Edit text";
      exec = "emacsclient --reuse-frame --no-wait --quiet --suppress-output --alternate-editor=emacs %F";
      genericName = "Text Editor";
      icon = "emacs";
      mimeType = [
        "application/x-shellscript"
        "text/english"
        "text/plain"
        "text/x-c"
        "text/x-c++"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-makefile"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
      ];
      name = "Emacs";
      startupNotify = false;
      terminal = false;
      type = "Application";
    };
    emacs-mail = disabled;
    emacsclient = disabled;
    emacsclient-mail = disabled;
  };
}
