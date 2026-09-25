{
  flake.modules.nixos.terminal = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty ];
  };
}
