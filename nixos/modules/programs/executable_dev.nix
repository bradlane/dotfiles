{
  flake.modules.nixos.dev = { pkgs, ... }: {
    programs.git.enable = true;
    programs.lazygit.enable = true;

    # neovim lives in its own aspect (modules/programs/neovim.nix): it is a
    # wrapper carrying the language servers and formatters that mason.nvim
    # used to install, which does not work on NixOS.

    environment.systemPackages = with pkgs; [
      delta
      jq
      gh
    ];
  };
}
