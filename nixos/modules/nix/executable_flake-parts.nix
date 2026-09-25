{ inputs, ... }:
{
  # Provides `flake.modules.<class>.<name>`, the namespace the dendritic
  # pattern uses to publish reusable aspects. Consumed as
  # `self.modules.nixos.<name>` from host files.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  # Only Linux: every `perSystem` output in this flake is a Wayland
  # compositor or shell, which does not evaluate on Darwin.
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
