self: super: rec {
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-session = gsuper.gnome-session.overrideAttrs {
      passthru.providedSessions = [ "gnome" ];
      postFixup = ''
        rm -rf "${placeholder "sessions"}"/share/xsessions
      '';
    };
    nautilus = gsuper.nautilus.overrideAttrs (old: {
      preFixup = old.preFixup + ''
        gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${gnome.totem}/share")
      '';
    });
  });
}
