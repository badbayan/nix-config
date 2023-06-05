{
  imports = [
    ./acme.nix
    ./miniflux.nix
    #./nextcloud.nix
    ./nginx.nix
    #./prosody.nix
  ];

  networking.domain = "badbayan.duckdns.org";
}
