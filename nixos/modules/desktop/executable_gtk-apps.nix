{
  # Common GTK desktop applications. Depends on the theming/portal/dconf
  # plumbing in the `gtk` aspect -- import both together.
  flake.modules.nixos.gtk-apps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nautilus # GTK4 file manager
      sushi # quick-look preview for nautilus (Space bar)
      gnome-text-editor
      loupe # GTK4 image viewer
      evince # PDF/document viewer
      file-roller # archive manager; backs nautilus' "Extract Here"
      swappy # screenshot annotation -- pairs with niri's Print binds
      cliphist # clipboard history over wl-clipboard
      wl-clipboard
      ffmpegthumbnailer # video thumbnails for nautilus/tumbler
    ];

    # Freedesktop thumbnailer daemon; nautilus and other GTK file managers
    # use it for non-image previews (video, fonts, PDFs via evince's own
    # thumbnailer).
    services.tumbler.enable = true;
  };
}
