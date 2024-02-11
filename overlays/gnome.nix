_: prev: rec {
  gnome = prev.gnome.overrideScope' (_: prev': {
    gnome-session = prev'.gnome-session.overrideAttrs {
      passthru.providedSessions = [ "gnome" ];
      postFixup = ''
        rm -rf "${placeholder "sessions"}"/share/xsessions
      '';
    };
    nautilus = prev'.nautilus.overrideAttrs (old: {
      preFixup = old.preFixup + ''
        gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${gnome.totem}/share")
      '';
    });
  });
}
