{
  flake.modules.nixos.gtk = { pkgs, ... }: {
    # GTK3/4 apps (Nautilus, gnome-text-editor, file-roller) store settings
    # via dconf/gsettings and are silently broken without it running.
    programs.dconf.enable = true;

    # Makes Qt apps (if any ever show up) pick up the GTK theme instead of
    # falling back to an unstyled default.
    qt = {
      enable = true;
      platformTheme = "gtk3";
    };

    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
      gsettings-desktop-schemas
      nerd-fonts.jetbrains-mono
    ];

    environment.sessionVariables.GTK_THEME = "Adwaita:dark";

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        inter
      ];
      fontconfig.defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    # File-picker + screencast portals for GTK apps under niri.
    #
    # VERIFY ON HOST: the wrapper-modules niri wrapper may already register a
    # portal backend of its own -- `nixos-rebuild build` will warn about a
    # duplicate/ambiguous portal implementation if so, in which case drop
    # whichever of these two is redundant.
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome # screencast/screenshot, matches niri's own docs
        xdg-desktop-portal-gtk # file chooser + settings fallback
      ];
    };

    # niri has no privilege-prompt UI of its own; GTK apps that hit polkit
    # (gnome-disk-utility, etc.) need an agent running in the session.
    #
    # VERIFY ON HOST: if noctalia-shell already ships a polkit agent, this is
    # redundant -- check for a second auth dialog / duplicate agent warnings
    # in `journalctl --user -u polkit-gnome-authentication-agent-1` before
    # relying on this.
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
