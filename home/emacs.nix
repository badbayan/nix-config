{ config, pkgs, ... }:
let
  disabled = import ./disabledapp.nix;
  emacs = (pkgs.emacs29-pgtk.override {
    withNativeCompilation = false;
    withTreeSitter = true;
  }).pkgs.withPackages (epkgs: with epkgs; [
    treesit-grammars.with-all-grammars
  ]);
in {
  programs.emacs = {
    enable = true;
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
