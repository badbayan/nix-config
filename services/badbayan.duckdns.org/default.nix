{
  imports = [
    ./acme.nix
    ./miniflux.nix
    #./nextcloud.nix
    ./nginx.nix
    #./prosody.nix
    #./vaultwarden.nix
  ];

  networking.domain = "badbayan.duckdns.org";
}
