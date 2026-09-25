{
  flake.modules.nixos.vmware-guest = { config, lib, pkgs, ... }: {
    # open-vm-tools: vmtoolsd, time sync, guest resize, udev rules, and the
    # vmblock fuse mount used for host<->guest drag-and-drop / clipboard.
    virtualisation.vmware.guest = {
      enable = true;

      # IMPORTANT: `headless` defaults to `!services.xserver.enable`, and a
      # niri/Wayland guest never enables xserver -- so the default would
      # silently pick `open-vm-tools-headless` and drop the vmblock mount
      # and the vmware-user-suid-wrapper, i.e. no clipboard sharing. Pin it.
      headless = false;
    };

    # --- accelerated 3D -------------------------------------------------
    #
    # Fusion's virtual GPU is driven by the `vmwgfx` KMS driver plus Mesa's
    # `svga` Gallium driver (enabled in nixpkgs' Mesa by default), which is
    # what turns SVGA3D into real GL.
    #
    # vmwgfx is deliberately NOT listed in `boot.initrd.kernelModules`. udev
    # autoloads it for the SVGA PCI device once userspace is up, which is
    # what the nixpkgs vmware-guest module relies on -- it only puts the
    # *storage* modules (mptspi, vmw_pvscsi) in the initrd. Forcing a DRM
    # driver in the initrd only buys a cosmetically nicer early console, and
    # if it binds without a usable mode there is no simpledrm fallback left,
    # which black-screens the console before you can read any boot messages.
    #
    # 3D also has to be enabled host-side, in the VM's .vmx:
    # `mks.enable3d = "TRUE"` (Fusion: Settings -> Display -> Accelerate 3D
    # Graphics), ideally with a raised `svga.graphicsMemoryKB`.
    #
    # vmwgfx is NOT x86-only: Fusion on Apple Silicon drives arm64 guests
    # through the same SVGA device and gets OpenGL 4.3, provided the VM is
    # on virtual hardware version 20+ and the guest kernel is 5.19 or newer.
    hardware.graphics = {
      enable = true;
      # 32-bit GL only exists on x86_64; there is no multilib story on arm64.
      enable32Bit = lib.mkDefault pkgs.stdenv.hostPlatform.isx86_64;
    };

    # --- shared folders (HGFS) ------------------------------------------
    #
    # The nixpkgs vmware-guest module does not wire this up. Modern
    # open-vm-tools has no HGFS kernel module; it is FUSE-only via
    # `vmhgfs-fuse`, built against fuse3 here.
    #
    # `programs.fuse.enable` provides the `mount.fuse3` helper that mount(8)
    # dispatches to for a `fuse.<subtype>` fsType, plus the setuid
    # fusermount3 wrapper. `userAllowOther` uncomments `user_allow_other` in
    # /etc/fuse.conf, without which the `allow_other` option below is
    # rejected.
    programs.fuse = {
      enable = true;
      userAllowOther = true;
    };
    system.fsPackages = [ config.virtualisation.vmware.guest.package ];

    fileSystems."/mnt/hgfs" = {
      device = ".host:/";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = [
        "allow_other"
        "auto_unmount"
        "defaults"
        # vmhgfs-fuse presents everything as owned by the mounting user
        # (root), so map it to the first normal user / `users` group.
        "uid=1000"
        "gid=100"
        "umask=022"
        # Mount lazily on first access and never block boot: a VM with no
        # shared folders configured has no `.host:/` to mount.
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
