{
  inputs,
  withSystem,
  ...
}:
{
  flake.modules.nixos.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.niri);
    };

    # niri talks to logind for session/idle handling, and the media-key binds
    # below rely on the seat being "active" so brightnessctl can use the
    # login1 SetBrightness API.
    security.polkit.enable = true;
  };

  perSystem =
    { pkgs, lib, self', ... }:
    let
      noctalia = lib.getExe self'.packages.noctalia;
      ipc = args: "${noctalia} ipc call ${args}";

      wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      brightnessctl = lib.getExe pkgs.brightnessctl;
      playerctl = lib.getExe pkgs.playerctl;

      # noctalia's IPC gives us its OSD, but `ipc call` exits non-zero when
      # the shell is not running, so each hardware key falls back to the
      # underlying tool. Media keys also fire while the session is locked.
      hwKey = primary: fallback: _: {
        props.allow-when-locked = true;
        content.spawn-sh = "${primary} || ${fallback}";
      };

      lockedKey = cmd: _: {
        props.allow-when-locked = true;
        content.spawn-sh = cmd;
      };

      workspaceBinds = lib.listToAttrs (
        lib.concatMap
          (n: [
            (lib.nameValuePair "Mod+${toString n}" { focus-workspace = n; })
            (lib.nameValuePair "Mod+Ctrl+${toString n}" { move-column-to-workspace = n; })
          ])
          (lib.range 1 9)
      );
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          spawn-at-startup = [ noctalia ];

          input = {
            keyboard.xkb = {
              layout = "us";
              options = "caps:super";
            };
            touchpad = {
              tap = _: { };
              natural-scroll = _: { };
              dwt = _: { }; # disable-while-typing
            };
          };

          layout.gaps = 5;

          binds = workspaceBinds // {
            # ---- hardware keys ------------------------------------------
            # niri ships no implicit binds: anything not listed here, media
            # keys included, is simply not bound.
            "XF86AudioRaiseVolume" = hwKey (ipc "volume increase") "${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = hwKey (ipc "volume decrease") "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = hwKey (ipc "volume muteOutput") "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioMicMute" = hwKey (ipc "volume muteInput") "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            "XF86MonBrightnessUp" = hwKey (ipc "brightness increase") "${brightnessctl} set 5%+";
            "XF86MonBrightnessDown" = hwKey (ipc "brightness decrease") "${brightnessctl} set 5%-";

            "XF86AudioPlay" = lockedKey "${playerctl} play-pause";
            "XF86AudioStop" = lockedKey "${playerctl} stop";
            "XF86AudioNext" = lockedKey "${playerctl} next";
            "XF86AudioPrev" = lockedKey "${playerctl} previous";

            # ---- session ------------------------------------------------
            "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
            "Mod+S".spawn-sh = ipc "launcher toggle";
            "Mod+Shift+L".spawn-sh = ipc "lockScreen lock";
            "Mod+Shift+Slash".show-hotkey-overlay = _: { };
            "Mod+Shift+E".quit = _: { };
            "Mod+Q".close-window = _: { };

            # ---- focus --------------------------------------------------
            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+J".focus-window-down = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Page_Down".focus-workspace-down = _: { };
            "Mod+Page_Up".focus-workspace-up = _: { };
            "Mod+Tab".focus-window-previous = _: { };

            # ---- move ---------------------------------------------------
            "Mod+Ctrl+H".move-column-left = _: { };
            "Mod+Ctrl+L".move-column-right = _: { };
            "Mod+Ctrl+J".move-window-down = _: { };
            "Mod+Ctrl+K".move-window-up = _: { };
            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = _: { };
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = _: { };
            "Mod+BracketLeft".consume-or-expel-window-left = _: { };
            "Mod+BracketRight".consume-or-expel-window-right = _: { };

            # ---- sizing -------------------------------------------------
            "Mod+R".switch-preset-column-width = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+Shift+F".fullscreen-window = _: { };
            "Mod+C".center-column = _: { };
            "Mod+V".toggle-window-floating = _: { };
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            # ---- screenshots --------------------------------------------
            "Print".screenshot = _: { };
            "Ctrl+Print".screenshot-screen = _: { };
            "Alt+Print".screenshot-window = _: { };
          };
        };
      };

      # export settings cmd: nix run nixpkgs#noctalia-shell ipc call state all > ./modules/desktop/noctalia.json
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
      };
    };
}
