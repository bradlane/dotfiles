{
  inputs,
  withSystem,
  ...
}:
{
  flake.modules.nixos.neovim = { pkgs, ... }: {
    environment.systemPackages = [
      (withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.neovim))
    ];

    environment.variables.EDITOR = "nvim";
    environment.shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      # The lua config stays where it is, at ~/.config/nvim, managed by
      # lazy.nvim. Nix only supplies the binaries that used to come from
      # mason.nvim, which cannot work on NixOS: mason downloads prebuilt
      # dynamically-linked executables and there is no
      # /lib64/ld-linux-*.so.2 to run them against.
      #
      # These go on *neovim's* PATH rather than into environment.systemPackages
      # so that ~19 language servers do not leak into the login shell. The
      # wrapper appends to PATH, it does not replace it, so git/curl/etc. are
      # still found normally.
      packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;

        runtimePkgs = with pkgs; [
          # --- language servers (was mason-tool-installer ensure_installed)
          ansible-language-server # ansiblels
          basedpyright
          bash-language-server # bashls
          biome # also the json formatter
          dockerfile-language-server # dockerls
          gopls
          vscode-langservers-extracted # jsonls
          lua-language-server # lua_ls
          marksman
          powershell-editor-services # powershell_es
          ruff # LSP + python formatter
          sqls
          yaml-language-server # yamlls

          # --- linters / formatters (conform.nvim + mason list)
          shellcheck
          shfmt
          stylua
          yamlfmt
          gotools # goimports
          gofumpt
          powershell # pwsh, for the psscriptanalyzer formatter

          # --- nvim-treesitter compiles parsers at runtime on the `main`
          # branch API (`require("nvim-treesitter").install{...}`), so it
          # needs a C compiler and the tree-sitter CLI available.
          gcc
          tree-sitter
        ];

        # nvim-lspconfig's powershell_es wants a `bundle_path` directory.
        # nixpkgs lays it out under lib/, so hand the location to the lua
        # config through the environment instead of hardcoding a store path
        # in a file that also has to work on macOS.
        env.NVIM_PSES_BUNDLE_PATH = "${pkgs.powershell-editor-services}/lib/powershell-editor-services";
      };
    };
}
