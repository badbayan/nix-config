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
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };
    kernelPackages = pkgs.linuxPackages_5_15;
    kernelParams = [ "acpi_backlight=vendor" "tsc=nowatchdog" ];
  };

  age.secrets = with inputs.self; {
    yama-wg0.file = secrets.yama-wg0;
    yama-wg0-oneplus.file = secrets.yama-wg0-oneplus;
    yama-wg0-fail2banana.file = secrets.yama-wg0-fail2banana;
    yggdrasil.file = secrets.yggdrasil;
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
          privateKeyFile = config.age.secrets.yama-wg0.path;
          peers = [
            { # OnePlus
              publicKey = "i7tPC3P9xTMK6y6b+UU39Ez/hDd7p75iJchXXKxT/ww=";
              presharedKeyFile = config.age.secrets.yama-wg0-oneplus.path;
              allowedIPs = [ "10.0.0.10/32" ];
            }
            { # fail2banana.ru
              publicKey = "gcP/mUmJ1t1yWU1YKq1xMF53y9+COYooURmQuRTmLXM=";
              presharedKeyFile = config.age.secrets.yama-wg0-fail2banana.path;
              endpoint = "37.192.91.95:51820";
              allowedIPs = [ "10.0.0.50/32" ];
            }
          ];
        };
      };
    };
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    crawlTiles
    deluge
    easyeffects
    gzdoom
    legendary-gl
    mednafen
    mednaffe
    wineWowPackages.waylandFull
    winetricks
  ];

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
    yggdrasil = {
      enable = true;
      configFile = config.age.secrets.yggdrasil.path;
      persistentKeys = false;
    };
  };
}
