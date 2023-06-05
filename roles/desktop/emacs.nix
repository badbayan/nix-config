{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacs-unstable-pgtk.override { nativeComp = false; };
  };
}
