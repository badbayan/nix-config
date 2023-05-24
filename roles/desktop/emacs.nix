{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [(import inputs.emacs-overlay)];

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacsUnstablePgtk.override { nativeComp = false; };
  };
}
