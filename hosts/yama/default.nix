{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    services.openssh
    services.dnsmasq
    services.yggdrasil
    services.minidlna

    services.postgresql
    services.badbayan.duckdns.org

    roles.gnome
  ];

  i18n.defaultLocale = "ru_RU.UTF-8";
  time.timeZone = "Asia/Novosibirsk";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
      timeout = 2;
    };

    kernelParams = [ "quiet" "acpi_backlight=vendor" "tsc=nowatchdog" ];
    kernelPackages = pkgs.linuxPackages_5_15;
    tmp.useTmpfs = true;
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
              endpoint = "fail2banana.ru:51820";
              allowedIPs = [ "10.0.0.50/32" ];
            }
          ];
        };
      };
    };
  };

  services = {
    archisteamfarm.enable = true;
    fstrim.enable = true;
  };
}
