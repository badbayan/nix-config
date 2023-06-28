{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    domains."badbayan.duckdns.org"
    users.aya
  ];

  roles = {
    gnome.enable = true;
    virt.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackagesFor
      (pkgs.linux_5_15.override {
        argsOverride = rec {
          version = "5.15.117";
          modDirVersion = version;
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
            sha256 = "17r3yyy4yzxyi4n1ri3sb42m9y1vnn4dcc0zli04n00f7hgk7a59";
          };
        };
      });
    kernelParams = [ "acpi_backlight=vendor" "tsc=nowatchdog" ];
  };

  networking = {
    hostName = "yama";

    dhcpcd.enable = true;
    networkmanager.enable = false;
    wireless.enable = false;

    interfaces.lo.ipv6.addresses = [{
      address = "304:7039:ade1:9854::bad";
      prefixLength = 64;
    }];

    firewall.allowedTCPPorts = [ 3389 ];
    firewall.allowedUDPPorts = [ 51820 ];

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.0.0.1/24" ];
          listenPort = 51820;
          privateKeyFile = "/root/secrets/wireguard/wg0.key";
          peers = [
            { # OnePlus
              publicKey = "i7tPC3P9xTMK6y6b+UU39Ez/hDd7p75iJchXXKxT/ww=";
              presharedKeyFile = "/root/secrets/wireguard/wg0-peer0.key";
              allowedIPs = [ "10.0.0.10/32" ];
            }
            { # fail2banana.ru
              publicKey = "gcP/mUmJ1t1yWU1YKq1xMF53y9+COYooURmQuRTmLXM=";
              presharedKeyFile = "/root/secrets/wireguard/wg0-peer1.key";
              endpoint = "37.192.91.95:51820";
              allowedIPs = [ "10.0.0.50/32" ];
            }
          ];
        };
      };
    };
  };

  services = {
    archisteamfarm.enable = true;
    dnsmasq.enable = true;
    fstrim.enable = true;
    minidlna = {
      enable = true;
      settings.media_dir = [
        "A,/home/aya/Music"
        "V,/home/aya/Videos"
      ];
    };
    openssh.enable = true;
    postgresql.package = pkgs.postgresql_15;
    yggdrasil.enable = true;
  };
}
