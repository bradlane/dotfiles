{
  # Transcribed from `nixos-generate-config` output on the VM itself.
  # Regenerate with `nixos-generate-config --show-hardware-config` and paste
  # the body below -- the contents go *inside* the
  # `flake.modules.nixos.fusionvm-hardware` attribute, not at file top level,
  # since every .nix file under modules/ is a flake-parts module.
  #
  # The VMware storage/graphics bits are not repeated here:
  # `flake.modules.nixos.vmware-guest` contributes `mptspi` and `vmwgfx`.
  flake.modules.nixos.fusionvm-hardware = { lib, ... }: {
    boot.initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "xhci_pci"
      "nvme"
      "usbhid"
      "sr_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    # NOTE: unlike lappy486, "/" here has no `subvol=` option, so it mounts
    # the btrfs top-level subvolume (subvolid=5). That means the `home` and
    # `nix` subvolumes are also visible as plain directories under "/" in
    # addition to being mounted at /home and /nix. Harmless, but it makes
    # snapshotting "/" awkward later.
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/bc52f2f1-2d15-478d-a0b4-db7b3a424fe5";
      fsType = "btrfs";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/bc52f2f1-2d15-478d-a0b4-db7b3a424fe5";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/bc52f2f1-2d15-478d-a0b4-db7b3a424fe5";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/10D6-F397";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/f8145b4a-1007-476e-8101-a9e235f52ce3"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  };
}
