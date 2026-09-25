{
  flake.modules.nixos.users = {
    users.users.brad = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video" # backlight udev fallback
        "audio"
        "networkmanager"
      ];
    };
  };
}
