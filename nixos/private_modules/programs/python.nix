{
  flake.modules.nixos.python = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.uv ];

    # uv installs interpreters by downloading prebuilt python-build-standalone
    # CPython, which are ordinary dynamically-linked ELF binaries and so
    # cannot run on NixOS unaided -- there is no /lib64/ld-linux-*.so.2.
    # nix-ld puts a shim there (via `environment.ldso`) and exports NIX_LD and
    # NIX_LD_LIBRARY_PATH, which is also what lets binary wheels from PyPI
    # find their shared libraries.
    programs.nix-ld.enable = true;

    # `libraries` is a list option, and the nix-ld module already contributes
    # a base set (zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2
    # libxml2 acl libsodium util-linux xz systemd), so everything here is
    # appended to that rather than replacing it.
    #
    # When a wheel fails with `ImportError: libfoo.so.N: cannot open shared
    # object file`, find the owning package with
    # `nix-locate --top-level --whole-name libfoo.so.N` and add it here.
    programs.nix-ld.libraries = with pkgs; [
      libffi # ctypes, cffi
      libxcrypt # crypt
      ncurses # curses
      readline
      expat
      sqlite
      glib # opencv, pygobject
      libGL # opencv, matplotlib/Qt backends
    ];
  };
}
