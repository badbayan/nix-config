{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    podman
    qemu
    virt-manager
  ];

  virtualisation = {
    containers.enable = true;
    libvirtd.enable = true;
  };
}
