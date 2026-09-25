{ self, inputs, ... }:
{
  flake.modules.nixos.fusionvm = { lib, pkgs, ... }: {
    imports = with self.modules.nixos; [
      fusionvm-hardware
      vmware-guest
      audio
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

    # `backlight` is deliberately absent: a VM has no /sys/class/backlight,
    # so niri's XF86MonBrightness binds are no-ops here.

    # This host uses tuigreet, not the noctalia greeter that lappy486 uses.
    #
    # noctalia-greeter hangs on this host: greetd starts it, PAM opens the
    # greeter session, and then nothing happens and no session is ever
    # created. `niri-session` run by hand from a TTY works fine, and niri and
    # noctalia-shell both come up normally once logged in through tuigreet,
    # so the GPU, the niri wrapper and the generated config are all fine --
    # the fault is in the greeter alone. Adding accounts-daemon and the
    # state dir (see modules/desktop/greetd.nix) changed the failure but did
    # not fix it. Not pursued further; tuigreet is a TUI and needs no GPU.
    #
    # `useTextGreeter` is what stops systemd boot messages from scribbling
    # over the TUI: it sets StandardInput=tty, TTYPath, TTYReset and friends
    # on greetd.service.
    services.greetd = {
      settings.default_session.command =
        "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
      useTextGreeter = true;
    };

    networking = {
      hostName = "fusionvm";
      networkmanager.enable = true;
    };
    
    services.openssh.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # See the comment in modules/hosts/lappy486/configuration.nix -- keep
    # this at the release you installed from, and do not bump it later.
    system.stateVersion = "26.05";
  };

  flake.nixosConfigurations.fusionvm = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ self.modules.nixos.fusionvm ];
  };
}
