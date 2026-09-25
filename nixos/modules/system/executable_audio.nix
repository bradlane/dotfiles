{
  flake.modules.nixos.audio = { pkgs, ... }: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Lets pipewire acquire realtime priority, which it needs to avoid
    # xruns/crackling under load.
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      wireplumber # wpctl, used as the media-key fallback
      playerctl # MPRIS control for the play/next/prev keys
      pavucontrol
    ];
  };
}
