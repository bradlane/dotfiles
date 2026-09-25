{
  flake.modules.nixos.cli = { pkgs, ... }: {
    programs.yazi.enable = true;
    programs.bat.enable = true;
    programs.zoxide.enable = true;
    programs.nushell.enable = true;

    environment.systemPackages = with pkgs; [
      fd
      fzf
      ripgrep
      eza
      tree
      wget
    ];
  };
}
