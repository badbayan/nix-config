{ ... }:

{
  users = {
    users = {
      aya = {
        isNormalUser = true;
        description = "badbayan";
        extraGroups = [ "wheel" "audio" "video" "kvm" "adbusers" ];
        createHome = true;
        homeMode = "711";
      };
    };
  };
}
