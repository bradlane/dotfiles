{
  flake.modules.nixos.browsers = { pkgs, ... }: {
    programs.firefox.enable = true;

    # `programs.chromium` only writes enterprise policy files, it installs
    # nothing, so the browser itself comes from systemPackages.
    environment.systemPackages = [ pkgs.ungoogled-chromium ];
  };
}
