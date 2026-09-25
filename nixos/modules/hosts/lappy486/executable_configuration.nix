{ self, inputs, ... }:
{
  flake.modules.nixos.lappy486 = { config, lib, pkgs, ... }: {
    imports = with self.modules.nixos; [
      lappy486-hardware
      audio
      backlight
      browsers
      cli
      dev
      greetd
      gtk
      gtk-apps
      locale
      neovim
      niri
      nix-settings
      python
      terminal
      users
    ];

    networking = {
      hostName = "lappy486";
      networkmanager = {
        enable = true;
        wifi.powersave = false;
        wifi.backend = "iwd";
      };
      # NetworkManager drives iwd here, so keep the wpa_supplicant and dhcpcd
      # paths out of the way.
      wireless.enable = lib.mkForce false;
      dhcpcd.enable = false;
    };

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      # Hibernation. resume_offset is the physical offset of /swap/swapfile;
      # it must be regenerated (`btrfs inspect-internal map-swapfile -r`) if
      # the swapfile is ever recreated.
      resumeDevice = "/dev/disk/by-uuid/1bbfea0d-c32c-4145-ac3d-b4d82fa43ac4";
      kernelParams = [ "resume_offset=1058048" ];
    };

    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 64 * 1024;
      }
    ];

    services.upower.enable = true;

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;

    # nVidia Quadro M2000M (GM107, Maxwell).
    #
    # The 580 branch is the last one NVIDIA ships for Maxwell/Pascal/Volta;
    # it is a legacy production branch with security and new-kernel
    # compatibility fixes through October 2028. Anything newer
    # (`production` = 595, `new_feature` = 610) has dropped Maxwell, and
    # there is no 550 branch in nixpkgs -- it is EOL upstream and was
    # removed, so 580 is the closest maintained equivalent.
    nixpkgs.config.nvidia.acceptLicense = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.nvidia = {
      modesetting.enable = true;
      # Saves/restores VRAM across suspend. Reliable on the 580 branch; set
      # this back to false if the dGPU comes back corrupted after resume.
      powerManagement.enable = true;
      # Must stay false: the open kernel modules require Turing or newer.
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Deliberately does NOT set GBM_BACKEND / __GLX_VENDOR_LIBRARY_NAME.
    # Under `prime.offload` niri and every client run on the Intel iGPU and
    # the Quadro stays parked; `nvidia-offload <cmd>` (from
    # `enableOffloadCmd`) sets those two variables per-process for the apps
    # that want the dGPU. Setting them globally defeats the offload setup
    # and holds the dGPU at full power.
    environment.sessionVariables = {
      # Force electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "26.05"; # Did you read the comment?
  };

  flake.nixosConfigurations.lappy486 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ self.modules.nixos.lappy486 ];
  };
}
