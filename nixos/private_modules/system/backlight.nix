{
  flake.modules.nixos.backlight = { pkgs, ... }: {
    # nixpkgs builds brightnessctl with ENABLE_SYSTEMD=1, so inside an active
    # logind session it sets brightness over the org.freedesktop.login1
    # D-Bus API and needs no special file permissions at all. Its shipped
    # 90-brightnessctl.rules is installed as a fallback for the non-session
    # case; it chgrp's /sys/class/backlight/*/brightness to `video`.
    #
    # This replaces the previous `hardware.acpilight.enable` (X11-oriented)
    # plus the world-writable `chmod a+w` udev rule.
    environment.systemPackages = [ pkgs.brightnessctl ];
    services.udev.packages = [ pkgs.brightnessctl ];
  };
}
