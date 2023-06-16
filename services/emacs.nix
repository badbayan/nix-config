{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacs29-pgtk.override { withNativeCompilation = false; };
  };
}
