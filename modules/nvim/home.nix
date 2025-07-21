{ config, lib, pkgs, isHMStandaloneContext, ... }:

# TODO: Fix lua5.1 and luarocks issues
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  # Core home configuration for this module
  moduleHomeConfig = { lib, ... }: {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "neovide";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # [Optional] LuaJit
        luajit

        # Build tools
        gnumake
        gcc
        
        # Tools:
        # https://docs.astronvim.com/
        tree-sitter  # tree-sitter's auto_install feature

        ripgrep
        lazygit
        gdu
        bottom
        (pkgs.python3.withPackages (python-pkgs:
          with python-pkgs; [
            pip
            debugpy  # astrocommunity.pack.python
          ]))
        unzip
        
        # LSP build tools
        go
        nodejs

        # Plugin specific dependencies
        luajitPackages.luarocks
        pkg-config
        imagemagick
        imagemagick.dev
        ghostscript

        ## LSPs that should be installed by system:
        ## (commented out ones are installed via Mason.nvim)
        
        # This list is manually updated.
        # Check out for required LSPs here: https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack
        # Check out for LSP configs here: https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
        # Use :Mason to see list of LSPs managed by Mason.nvim

        # # astrocommunity.pack.nix
        nixd
        deadnix
        statix
        alejandra

        # astrocommunity.pack.lua
        # stylua
        luajitPackages.lua-lsp
        # selene

        # astrocommunity.pack.python
        # basedpyright
        # black
        # isort

        # astrocommunity.pack.kotlin
        kotlin
        # kotlin-language-server
        # ktlint

        # astrocommunity.pack.java
        # jdt-language-server
        # lemminx

        # astrocommunity.pack.typst
        # tinymist

        # astrocommunity.pack.verilog
        # verible
        verilator

        # astrocommunity.pack.cpp
        clang-tools  # clang-format

        # astrocommunity.pack.json
        vscode-langservers-extracted  # jsonls

        # astrocommunity.pack.bash
        # bash-language-server
        # shfmt
        # shellcheck
        bashdb

        # astrocommunity.pack.fish
        fish

        # astrocommunity.pack.hyprland
        # hyprls

        # astrocommunity.pack.markdown
        # marksman
        # prettierd
      ];
    };

    home.sessionVariables.PKG_CONFIG_PATH = ''
      ${pkgs.imagemagick.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    '';

    # Smart nvim config activation:
    # - If nvim config doesn't exist, clone from github
    # - If nvim config exists, skip
    # Therefore, config is fully mutable
    home.activation.nvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Make git from home-manager available
      export PATH="${pkgs.git}/bin:$PATH"

      if [ ! -d /home/${config.primaryUser}/.config/nvim ]; then
        echo "No nvim config found, cloning from github..."
        mkdir -p /home/${config.primaryUser}/.config/nvim
        git clone https://github.com/ButterSus/astronvim-dotfiles.git \
          /home/${config.primaryUser}/.config/nvim
        chmod -R u+w /home/${config.primaryUser}/.config/nvim
      else
        echo "Nvim config already exists, skipping..."
      fi
    '';
  };

in {
  options.modules.nvim = {
    enable = mkEnableOption "Enable Neovim configuration";

    enableXorgClipboard = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Xorg clipboard support for Neovim (xclip, xorg.xauth, xorgserver).";
    };
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig { inherit lib; }
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
