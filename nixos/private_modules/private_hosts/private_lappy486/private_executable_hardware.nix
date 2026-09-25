{
  flake.modules.nixos.lappy486-hardware = { config, lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1bbfea0d-c32c-4145-ac3d-b4d82fa43ac4";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/1bbfea0d-c32c-4145-ac3d-b4d82fa43ac4";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/1bbfea0d-c32c-4145-ac3d-b4d82fa43ac4";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    fileSystems."/swap" = {
      device = "/dev/disk/by-uuid/1bbfea0d-c32c-4145-ac3d-b4d82fa43ac4";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/B2A4-458D";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
