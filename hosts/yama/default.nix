{ config, pkgs, inputs, ... }:

{
  imports = with inputs.self; [
    ./hardware-configuration.nix

    domains."badbayan.duckdns.org"
    users.aya
  ];

  roles = {
    desktop = "gnome";
    virt.enable = true;
  };

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };
    kernel.sysctl."kernel.sysrq" = 1;
    kernelModules = [ "ddcci_backlight" ];
    kernelPackages = pkgs.linuxPackages_6_6;
    kernelParams = [ "acpi_backlight=vendor" "tsc=nowatchdog" ];
  };

  environment.persistence."/system/persist" = {
    directories = [
      "/etc/ssh"
      "/var/db/sudo"
      "/var/lib"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  fileSystems = {
    "/".options = [ "size=1G" "mode=755" ];
    "/etc/ssh" = {
      depends = [ "/system" ];
      neededForBoot = true;
    };
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/system" = {
      neededForBoot = true;
      options = [ "compress=zstd" ];
    };
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

    wireguard.interfaces = {
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

  programs = {
    atop.netatop.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    audacity
    crawlTiles
    eartag
    easyeffects
    gzdoom
    infra-arcana
    legendary-gl
    mednafen
    mednaffe
    transmission-remote-gtk
    wineWowPackages.waylandFull
    winetricks
  ];

  systemd.services.transmission.serviceConfig.BindPaths = [ "/system/data" ];

  services = {
    # archisteamfarm.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/system" ];
    };
    dnsmasq.enable = true;
    minidlna = {
      enable = true;
      settings.media_dir = [
        # "A,/system/data/music"
        "V,/system/data/videos"
      ];
    };
    openssh.enable = true;
    postgresql.package = pkgs.postgresql_15;
    transmission = {
      enable = true;
      group = "users";
      inherit (config.users.users.aya) home;
      openPeerPorts = true;
      settings = {
        incomplete-dir = config.services.transmission.settings.download-dir;
        incomplete-dir-enabled = false;
        peer-limit-global = 500;
        peer-limit-per-torrent = 100;
        speed-limit-up = 3200;
        speed-limit-up-enabled = true;
        umask = 18;
        watch-dir = config.services.transmission.settings.download-dir;
      };
      user = "aya";
    };
    yggdrasil = {
      enable = true;
      configFile = config.age.secrets.yggdrasil.path;
      persistentKeys = false;
    };
  };
}
