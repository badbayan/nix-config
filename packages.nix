{ inputs, ... }:
let inherit (import ./lib.nix { inherit inputs; }) mkSystem;
in {
  x86_64-linux = let
    mkIso = edition: conf: let
      edition' = if (edition == "minimal") then "minimal" else "base";
    in (mkSystem "x86_64-linux" ([
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${edition'}.nix"
      ./hosts/nixos ({ lib, pkgs, ... }: {
        isoImage = {
          inherit edition;
          isoBaseName = "nixos-${edition}";
          squashfsCompression = "zstd -Xcompression-level 3";
        };
        environment.systemPackages = lib.mkIf
          (edition != "minimal") (with pkgs; [ gparted ]);
      })
    ] ++ conf)).config.system.build.isoImage;
    mkVm = conf: (mkSystem "x86_64-linux" ([
      "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
      ./hosts/nixos {
        virtualisation = {
          cores = 2;
          memorySize = 4096;
        };
      }
    ] ++ conf)).config.system.build.vm;

  in {
    iso = mkIso "minimal" [];
    iso-gnome = mkIso "gnome" [{ roles.desktop = "gnome"; }];
    iso-kde = mkIso "plasma5" [{ roles.desktop = "kde"; }];
    vm = mkVm [{ virtualisation.qemu.options = [ "-nographic" ]; }];
    vm-gnome = mkVm [{
      virtualisation.qemu.options = [ "-vga virtio" ];
      roles.desktop = "gnome";
    }];
    vm-kde = mkVm [{
      virtualisation.qemu.options = [ "-vga virtio" ];
      roles.desktop = "kde";
    }];
  };
}
