# nixos flake — working notes

Facts in here were verified by reading the locked inputs, not from memory. Anything
version-specific is tagged with the revision it was checked against; re-verify after
`nix flake update`.

- nixpkgs pin when these notes were written: `0968519e14f7aa7d3e9b389682bd74d2b51c8ce8`
  (nixos-unstable, ~2026-09-03)
- flake-parts pin: `31729ca8cbdb4fa927b34e5f4353e6a83f39e993`

## Environment constraints

- **This repo is not a git repository.** There is no safety net — copy the tree
  somewhere before any restructuring.
- The machine used to edit this flake is **macOS with no `nix` installed**. Nothing
  here can be built or even evaluated locally. Every change must be verified on the
  target host with `nix flake check` / `nixos-rebuild`.
- Do not infer a host's hardware from the editing machine. `lappy486` and `fusionvm`
  are both remote from the editing session; wait for the user to supply
  `nixos-generate-config` output.

## Hosts

| Host | Platform | Notes |
|---|---|---|
| `lappy486` | `x86_64-linux` | Intel iGPU + nVidia **Quadro M2000M** (GM107, **Maxwell**), PRIME offload, btrfs w/ `subvol=root`, 64G swapfile + hibernation (`resume_offset`) |
| `fusionvm` | `aarch64-linux` | VMware Fusion guest on an **Apple Silicon** Mac, btrfs (root = top-level subvolid=5), swap partition |

## The dendritic pattern

Reference: <https://github.com/mightyiam/dendritic>

Every `.nix` file under `modules/` is a **flake-parts module**, auto-imported by
`import-tree`. `flake.nix` stays minimal (inputs + `mkFlake` + `import-tree ./modules`).
One file = one feature ("aspect"), organised by what it *does*, not by module class.

Aspects are published under `flake.modules.<class>.<name>` and consumed as
`self.modules.<class>.<name>`. Classes: `nixos`, `darwin`, `homeManager`, `generic`.

This namespace only exists if you import the flake-parts extra — done in
`modules/nix/flake-parts.nix`:

```nix
imports = [ inputs.flake-parts.flakeModules.modules ];
```

Gotchas learned the hard way:

- `flake.modules.nixos.*` does **not** populate `flake.nixosModules.*`. They are
  separate outputs. (`extras/modules.nix` just does
  `apply = mapAttrs (k: mapAttrs (addInfo k))` and stamps `_class`/`_file`.)
- **Dropping a plain NixOS module under `modules/` breaks evaluation.** import-tree
  imports it as a *flake-parts* module, so it fails on unknown options like
  `boot.initrd.availableKernelModules`. This bites when pasting
  `nixos-generate-config` output — the generated body must be nested *inside*
  `flake.modules.nixos.<host>-hardware`.
- import-tree **skips any path component starting with `_`**. Park scratch files as
  `modules/.../_scratch.nix`.
- Avoid `default.nix` under `modules/` — dendritic reserves that name for entry
  points (import-tree will happily import it anyway, which is confusing).
- To reference a `perSystem` package from inside a NixOS module, use `withSystem`,
  not `self.packages.${system}`:
  ```nix
  package = withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.niri);
  ```
- Host files declare both the aspect and the configuration, and must pass
  `specialArgs = { inherit inputs; }` or host modules cannot see `inputs`.

### Current layout

```
modules/
  nix/         flake-parts.nix (flakeModules.modules + systems), settings.nix
  system/      audio, backlight, locale, users
  programs/    cli, dev, browsers, terminal
  desktop/     niri.nix (+ noctalia.json), greetd.nix
  virtualisation/ vmware-guest.nix
  hosts/       lappy486/{configuration,hardware}.nix
               fusionvm/{configuration,hardware-configuration}.nix
```

Aspect names: `audio backlight browsers cli dev greetd locale niri nix-settings
terminal users vmware-guest`, plus `lappy486`, `lappy486-hardware`, `fusionvm`,
`fusionvm-hardware`.

`systems` is Linux-only — every `perSystem` output is a Wayland compositor/shell and
does not evaluate on Darwin.

## niri (via `wrapper-modules`)

**niri ships no implicit keybinds.** An empty or commented-out `binds` block means
*nothing* is bound, media keys included. This was the original cause of the
"laptop volume/brightness keys don't work" bug — nothing was wrong at the pipewire or
backlight layer.

**Status: fixed and confirmed working on `lappy486`** (volume, mute and brightness
keys). The binds live in `modules/desktop/niri.nix`; each hardware key runs the
noctalia IPC call with a `|| <tool>` fallback and `allow-when-locked=true`.

`inputs.wrapper-modules.wrappers.niri.wrap` settings schema
(`wrapperModules/n/niri/module.nix`): `binds`, `layout`, `spawn-at-startup`,
`spawn-sh-at-startup`, `window-rules`, `layer-rules`, `workspaces`, `outputs`,
`extraConfig`, plus freeform passthrough via `wlib.toKdl`.

Nix → KDL conversion rules:

```nix
"Mod+T".spawn-sh = "alacritty";        # spawn-sh "alacritty"
"Mod+Q".close-window = _: { };         # no-arg action  ->  MUST be `_: { }`
"Mod+0".focus-workspace = 0;           # focus-workspace 0
"Mod+Minus".set-column-width = "-10%";
"XF86AudioMute" = _: {                 # node properties
  props.allow-when-locked = true;      #   XF86AudioMute allow-when-locked=true {
  content.spawn-sh = "...";            #     spawn-sh "..."
};                                     #   }
```

- Media/hardware keys need `allow-when-locked=true` to work over the lock screen.
- The wrapper runs `niri validate` in `installPhase`, so a wrong action name is a
  **build failure with a real error** rather than a silent no-op. Lean on this.
- Escape hatches: `disableConfigValidation`, `disableConfigHotReload`,
  `extraSettings` (repeated nodes, e.g. `include`), `"config.kdl".content`
  (overrides the generated config wholesale).
- The wrapper adds an `X-Reload-Triggers` + `ExecReload` to the niri user unit, so
  config hot-reloads on rebuild (needs niri 26.04+).
- If the compositor picks the wrong GPU, the fix is `debug.render-drm-device`
  (check `ls -l /dev/dri/by-path/`), not global `GBM_BACKEND`.

## noctalia-shell

**The pinned nixpkgs has 4.7.7**, which is the QuickShell/QML era: JSON settings
(`modules/desktop/noctalia.json`, `.settings` key) and IPC of the form
`noctalia-shell ipc call <target> <function> [args]`.

Handlers confirmed in `Services/Control/IPCService.qml` @ `v4.7.7`:

- `volume`: `increase` `decrease` `muteOutput` `increaseInput` `decreaseInput`
  `muteInput` `togglePanel` `openPanel` `closePanel`
- `brightness`: `increase` `decrease` `set <value>`
- others: `bar` `settings` `launcher` `lockScreen` `notifications` `toast`
  `idleInhibitor` `darkMode` `nightLight` `colorScheme` `wallpaper` `wifi`
  `bluetooth` `network` `controlCenter` `sessionMenu` `dock` `monitors` `calendar`

**v5.x is a C++ rewrite** with TOML config and *flat* command names — `volume-up`,
`volume-down`, `volume-mute`, `brightness-up`, `brightness-set`, `osd-toggle`, etc.
When nixpkgs bumps to 5.x, every bind in `modules/desktop/niri.nix` and the
`noctalia.json` settings import must be rewritten.

Other behaviour:

- `ipc call` **exits non-zero when the shell is not running**, which is why the
  hardware-key binds are written as `noctalia … || <fallback tool>`.
- Its brightness backend shells out to `brightnessctl s N%` (or `ddcutil setvcp 10`
  for external displays, and `asdbctl` for Apple displays).
- Export current settings with
  `nix run nixpkgs#noctalia-shell ipc call state all > modules/desktop/noctalia.json`.

## greetd / greeters

`services.greetd` (nixos/modules/services/display-managers/greetd.nix) sets
`systemd.defaultUnit = "graphical.target"`, aliases itself to
`display-manager.service`, and is **fixed to VT1** (`services.greetd.vt` was removed).
Its unit has `Conflicts=getty@tty1.service`, so **restart it from tty2** or it kills
the shell you are sitting in.

- `services.greetd.useTextGreeter = true` is **required for TUI greeters** (tuigreet).
  It sets `StandardInput=tty`, `TTYPath=/dev/tty1`, `TTYReset`, `TTYVHangup`,
  `TTYVTDisallocate`. Without it systemd boot messages scribble over the TUI.
- tuigreet is **`pkgs.tuigreet`**, not `pkgs.greetd.tuigreet` — that package set was
  flattened into `by-name`. `mainProgram = "tuigreet"`, so `lib.getExe` works.
- `noctalia-greeter`: `mainProgram = "noctalia-greeter-session"`,
  `platforms = linux`, built against **`wlroots_0_20`**.

### Per-host greeter choice

`modules/desktop/greetd.nix` sets the noctalia greeter command with `lib.mkDefault` so
a host can override it without `mkForce`.

- `lappy486` → `noctalia-greeter` (works).
- `fusionvm` → **`tuigreet`. This is settled — do not re-litigate it.**

### noctalia-greeter on fusionvm: closed as won't-fix

It hangs. greetd starts it, PAM opens the greeter session, gnome-keyring starts, and
then nothing — no session is ever created and the screen stays black. Investigated
over several rounds and abandoned in favour of tuigreet, which works.

Established during that investigation, so nobody repeats it:

- **Not the GPU.** `niri-session` run by hand from a TTY works, and niri +
  noctalia-shell both come up normally after a tuigreet login. vmwgfx binds with 3D
  and `renderD128` exists. The fault is in the greeter alone.
- **accounts-daemon and `/var/lib/noctalia-greeter` are genuinely required** (upstream
  `nix/nixos-module.nix` sets both; nixpkgs ships only the package). Adding them
  changed the failure from a 25-minute hang to a sub-second exit, so they matter —
  but they are not sufficient. Both are kept in the shared aspect.
- **`systemd.services.greetd.environment` does not reach the greeter.** greetd builds
  a fresh environment for the greeter session. Confirmed: the variable appeared in
  `systemctl show greetd -p Environment` while the session script's own `echo` lines
  still never showed up. Upstream's PACKAGING.md says to use `env FOO=1 /path/...`
  inside `command`, and warns a bare `FOO=1 /path/...` is invalid in greetd's TOML.
- **Restarting greetd from another session is not a valid test.** The greeter is a
  wlroots compositor and needs libseat/DRM master on VT1, which logind only grants to
  the *active* session. Restarting from tty2 or SSH produces instant exits that look
  like a different bug. Test on a clean boot.
- Untried, if anyone picks this up again: add `noctalia-greeter` as a flake input and
  use upstream's `nix/nixos-module.nix` wholesale rather than reconstructing its
  wiring piecemeal; and raise `svga.graphicsMemoryKB` given the `No GMR memory
  available` warning.

### Debugging a black screen after boot — do this in order

1. **Does boot text appear before it goes black?** No text at all → KMS/DRM. Text then
   black → the graphical session. This splits the problem in one question.
2. **Test the session directly**: `niri-session` from a TTY as the normal user. This
   clears (or implicates) the compositor, GPU, wrapper and config in one command —
   do it *before* investigating anything GPU-side.
3. Only then look at greetd: `sudo journalctl -u greetd -b -e`.

Recovery: at the systemd-boot menu press `e` and append
`systemd.unit=multi-user.target` (add `nomodeset` if the console itself is dead).
**Caveat that cost real time here:** greetd does not start under
`multi-user.target`, so `journalctl -b -1 -u greetd` from a recovery boot shows
"No entries" — which looks like a finding but is an artefact. Use
`journalctl --list-boots` to identify the boot that actually failed.

## Backlight / brightnessctl

nixpkgs builds brightnessctl with **`ENABLE_SYSTEMD=1`**, so inside an *active logind
session* it sets brightness over the `org.freedesktop.login1` D-Bus API and needs **no
file permissions and no group membership at all**.

It also ships `90-brightnessctl.rules` (patched to use `${coreutils}/bin`), installed
via `services.udev.packages = [ pkgs.brightnessctl ]`, which chgrp's
`/sys/class/backlight/*/brightness` to `video` as a non-session fallback.

Do **not** use `hardware.acpilight.enable` (X11-oriented) or a
`chmod a+w /sys/class/backlight/...` udev rule (world-writable). Both were removed
from this config.

## nVidia — `nvidiaPackages` at the pinned rev

**There is no 550 branch in nixpkgs.** It is EOL upstream (last release 550.163.01)
and was removed. Available attributes:

| Attribute | Version |
|---|---|
| `production` (= `stable`) | 595.99.02 |
| `new_feature` | 610.57.04 |
| `beta` | 595.45.04 |
| `legacy_580` | 580.178.04 |
| `legacy_535` | 535.288.01 |
| `legacy_470` | 470.256.02 |
| `legacy_390` / `legacy_340` | 390.157 / 340.108 |
| `dc_590` / `dc_580` / `dc_570` | data-centre |
| `mkDriver` | `= generic`, for hand-pinning a version + hashes |

Hardware support boundaries:

- **`legacy_580` is the last branch supporting Maxwell / Pascal / Volta**, with
  security and new-kernel fixes through **October 2028**. 590+ dropped them. This is
  what `lappy486` uses for its Quadro M2000M.
- `legacy_470` is the last branch supporting **Kepler**.
- `hardware.nvidia.open` must be `false` below Turing.

Kernel compatibility: `legacy_470` is *not* stuck on old kernels — nixpkgs carries
AUR patches for it up through **Linux 6.17, 6.19 and 7.0**. (An earlier claim in this
repo's comments that it capped at 6.6 was wrong and has been removed.)

PRIME offload: setting `GBM_BACKEND=nvidia-drm` and `__GLX_VENDOR_LIBRARY_NAME=nvidia`
in `environment.sessionVariables` **contradicts** `prime.offload.enable`. Offload means
everything runs on the iGPU until you opt in per-process via the `nvidia-offload`
wrapper (from `enableOffloadCmd`), which sets exactly those two vars itself. Setting
them globally forces every client onto the dGPU and keeps it powered.

## VMware Fusion guest

`virtualisation.vmware.guest.enable = true` (nixos/modules/virtualisation/vmware-guest.nix)
gives: `vmtoolsd` unit, `open-vm-tools`, udev rules, `mptspi` in
availableKernelModules, `vmw_pvscsi` in initrd (x86 only), the vmblock FUSE mount for
drag-and-drop/clipboard, and the `vmware-user-suid-wrapper`.

**The `headless` trap:** it defaults to `!config.services.xserver.enable`. A
niri/Wayland guest never enables xserver, so the default resolves to `true`, silently
swapping in `open-vm-tools-headless` and dropping the vmblock mount and suid wrapper —
i.e. no clipboard sharing. Always set `headless = false` for a graphical guest.

**3D acceleration** — `vmwgfx` KMS driver + Mesa's `svga` Gallium driver (present in
nixpkgs' unconditional `galliumDrivers` list, so available on aarch64 too).

- `vmwgfx` is **not x86-only**: Fusion on Apple Silicon drives arm64 guests through
  the same SVGA device and delivers OpenGL 4.3, given virtual hardware version **20+**
  and guest kernel **≥5.19**. Only `vmw_pvscsi` is x86-specific.
- Host-side prerequisite, not a NixOS setting: `mks.enable3d = "TRUE"` in the `.vmx`
  (Fusion → Settings → Display → Accelerate 3D Graphics), plus a raised
  `svga.graphicsMemoryKB`.
- Verify in the guest with `glxinfo -B | grep -i renderer` — `llvmpipe` means
  acceleration is not active.
- **Do not put `vmwgfx` in `boot.initrd.kernelModules`.** udev autoloads it for the
  SVGA PCI device; the nixpkgs module deliberately puts only *storage* modules in the
  initrd. Forcing a DRM driver early only buys a prettier console, and if it binds
  without a usable mode there is no simpledrm fallback left, which black-screens the
  console before any boot messages are readable.

Confirmed working on `fusionvm` (Fusion on Apple Silicon, hardware version was already
fine — this was checked, not assumed):

```
$ ls -l /dev/dri/          -> card0 + renderD128 both present
$ sudo dmesg | grep vmwgfx -> "Running on SVGA version 3."
                              "Capabilities: ... 3D ..."
                              "Available shader model: SM_5_1X."
```

Note `dmesg` needs `sudo` (`kernel.dmesg_restrict`). Also present and apparently
harmless: `No GMR memory available. Graphics memory resources are very limited.` and
`Legacy memory limits: VRAM = 4096 KiB`.

**Shared folders (HGFS)** — the nixpkgs module does *not* handle this. Modern
open-vm-tools has no HGFS kernel module; it is FUSE-only via `vmhgfs-fuse`, built
against **fuse3**. Following the pattern of nixpkgs' own `tasks/filesystems/sshfs.nix`:

```nix
programs.fuse = {
  enable = true;          # provides the mount.fuse3 helper + setuid fusermount3
  userAllowOther = true;  # uncomments user_allow_other in /etc/fuse.conf;
};                        # without it the `allow_other` option is REJECTED
system.fsPackages = [ config.virtualisation.vmware.guest.package ];

fileSystems."/mnt/hgfs" = {
  device = ".host:/";
  fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  options = [ "allow_other" "auto_unmount" "defaults" "uid=1000" "gid=100"
              "umask=022" "nofail" "x-systemd.automount" ];
};
```

`vmhgfs-fuse` presents everything as owned by the mounting user (root), hence the
explicit `uid`/`gid`. `nofail` + `x-systemd.automount` keep boot working on a VM with
no shared folders configured.

**Confirmed working on `fusionvm`.** Because it is an automount, `/mnt/hgfs` looks
empty until something touches it — `cd /mnt/hgfs && ls` is the test, not `mount`.

## Python (`modules/programs/python.nix`)

uv + nix-ld. **Confirmed working on both hosts.**

- There is **no `programs.uv` NixOS module** — uv comes from `pkgs.uv` in
  `systemPackages`.
- nix-ld is the point of the aspect: `uv python install` downloads prebuilt
  python-build-standalone CPython, which are ordinary dynamically-linked ELF binaries
  and cannot run on NixOS unaided (no `/lib64/ld-linux-*.so.2`). `programs.nix-ld`
  installs a shim there via `environment.ldso` and exports `NIX_LD` /
  `NIX_LD_LIBRARY_PATH`, which is also what lets binary wheels from PyPI resolve
  their shared libraries.
- **`programs.nix-ld.libraries` appends, it does not replace.** The module populates
  it itself with a base set (`zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2
  libxml2 acl libsodium util-linux xz systemd`) as a plain `listOf package` with no
  `mkDefault`, so anything added merges in.
- Extending it: when a wheel fails with `ImportError: libfoo.so.N`, find the owner
  with `nix-locate --top-level --whole-name libfoo.so.N` and add it to `libraries`.

## Misc NixOS facts worth keeping

- `services.pipewire` does not imply realtime scheduling — **`security.rtkit.enable = true`**
  is needed separately, or pipewire cannot get RT priority.
- `programs.chromium.enable` only writes enterprise policy files; it installs no
  browser. The browser has to come from `systemPackages`.
- `hardware.enableAllFirmware` requires `allowUnfree`.
- `boot.supportedFilesystems` is derived from declared `fileSystems`, but there is no
  generic `fuse` filesystem module — a `fuse.*` fsType needs `programs.fuse.enable`
  explicitly.

## Verification checklist

```
nix flake check                              # evaluates ALL nixosConfigurations
nixos-rebuild boot --flake .#lappy486        # `boot`, not `switch`, for GPU/kernel
nixos-rebuild switch --flake .#fusionvm      # module changes; keeps prev generation
```

Use `boot` rather than `switch` for anything touching the kernel module or render
path, so the previous generation stays selectable in systemd-boot.
