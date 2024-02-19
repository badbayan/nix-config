_: prev: {
  xterm' = prev.writeShellScriptBin "xterm" ''
    if [ "$XDG_SESSION_TYPE" = wayland ]; then
      exec ${prev.foot}/bin/foot -d warning -a "''${TERMCLASS:-foot}" "$@"
    else
      exec ${prev.alacritty}/bin/alacritty --class "''${TERMCLASS:-Alacritty},Alacritty" "$@"
    fi
  '';
}
