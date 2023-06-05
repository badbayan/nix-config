{
  users = {
    users = {
      aya = {
        isNormalUser = true;
        description = "badbayan";
        extraGroups = [ "wheel" "audio" "video" "kvm" "libvirtd" "adbusers" ];
        createHome = true;
        homeMode = "711";
      };
    };
  };
}
