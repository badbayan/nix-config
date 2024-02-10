{ config, lib, inputs, ... }: {
  home-manager = {
    sharedModules = with lib; with inputs.self.modules.home;
      mkForce (builtins.concatLists [
        [({ lib, ... }: {
          fonts.fontconfig.enable = false;
          home.activation.zshrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [[ ! -e $HOME/.zshrc ]]; then
              $DRY_RUN_CMD touch $HOME/.zshrc
            fi
          '';
          home.stateVersion = config.system.stateVersion;
        }) git ]
        (optionals (config.roles.desktop != null) [
          chromium mpv terminals xdg xresources zathura
        ])
        (optionals (config.roles.desktop == "gnome") [
          dconf gtk
        ])
      ]);
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
