let
  aya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO+syWCXTaOxpR1Hu1AycSPZC/oelm6SV8rt6FjGCEz";

  yama = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvjuL+HhDwgogjbbPlMBJlWnYNzYh8ltWvSL0t5871q";
in {
  "duckdns.age".publicKeys = [ aya yama ];
  "miniflux.age".publicKeys = [ aya yama ];
  "nextcloud.age".publicKeys = [ aya yama ];
  "nix-serve.age".publicKeys = [ aya yama ];
  "yggdrasil.age".publicKeys = [ aya yama ];

  "yama-wg0.age".publicKeys = [ aya yama ];
  "yama-wg0-oneplus.age".publicKeys = [ aya yama ];
  "yama-wg0-fail2banana.age".publicKeys = [ aya yama ];
}
