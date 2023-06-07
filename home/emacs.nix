#{ pkgs, ... }:

{
  programs.emacs.enable = true;
  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [
        "--reuse-frame"
        "--no-wait"
        "--quiet"
        "--suppress-output"
      ];
    };
    defaultEditor = true;
    #package = pkgs.emacs-unstable-pgtk.override { nativeComp = false; };
  };
}
