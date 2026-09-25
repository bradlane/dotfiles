{
  flake.modules.nixos.greetd = { config, lib, pkgs, ... }:
    let
      greeterUser = config.services.greetd.settings.default_session.user;
    in
    {
      services.greetd = {
        enable = true;

        # mkDefault so a host can swap the greeter without needing mkForce.
        settings.default_session.command =
          lib.mkDefault "${pkgs.noctalia-greeter}/bin/noctalia-greeter-session";
      };

      # nixpkgs ships the noctalia-greeter *package* only. Upstream's own
      # nix/nixos-module.nix additionally sets up the two things below, and
      # without them the greeter starts, blocks, and never creates a session
      # -- which is a black screen, because its session script does
      # `exec >/dev/null 2>&1` and swallows the reason.
      #
      #   1. a state directory owned by the greeter user
      #   2. accounts-daemon, which the greeter queries over D-Bus
      #      (org.freedesktop.Accounts) to enumerate users
      systemd.tmpfiles.settings."10-noctalia-greeter"."/var/lib/noctalia-greeter".d = {
        user = greeterUser;
        group = "greeter";
        mode = "0750";
      };

      services.accounts-daemon.enable = true;

      # If the noctalia greeter ever needs debugging again: its session script
      # does `exec >/dev/null 2>&1` unless NOCTALIA_GREETER_LOG is set, which
      # is why greetd only reports "greeter exited without creating a session"
      # with no cause. Setting `systemd.services.greetd.environment` does NOT
      # work -- greetd builds a fresh environment for the greeter session, so
      # the variable never reaches it (confirmed: it showed up in
      # `systemctl show greetd -p Environment` while the script's own echo
      # lines still never appeared). Upstream's PACKAGING.md says to put it in
      # the command instead, and warns that a bare `FOO=1 /path/...` is
      # invalid in greetd's TOML:
      #
      #   command = "${pkgs.coreutils}/bin/env NOCTALIA_GREETER_LOG=stderr \
      #     WLR_LOG=info ${pkgs.noctalia-greeter}/bin/noctalia-greeter-session";
    };
}
