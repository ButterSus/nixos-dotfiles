{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

# TODO: Fix lua5.1 and luarocks issues
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  inherit (inputs) astronvim-dotfiles;

  # Core home configuration for this module
  moduleHomeConfig = { lib, ... }: {
    home.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";

      # For conditional nix-specific fragment of NeoVim config
      "NIX_NEOVIM" = 1;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # [Optional] LuaJit
        luajit

        # Build tools
        gnumake
        clang
        
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
        
        # luarocks
        luarocks
        
        # astrocommunity.pack.nix
        nixd
        deadnix
        statix
        alejandra
        
        # astrocommunity.pack.lua
        stylua
        luajitPackages.lua-lsp
        selene
        
        # astrocommunity.pack.python
        basedpyright
        black
        isort
        
        # astrocommunity.pack.typst
        tinymist
        
        # astrocommunity.pack.verilog
        verible
        verilator
        
        # astrocommunity.pack.cpp
        clang-tools
        
        # astrocommunity.pack.json
        vscode-langservers-extracted
        
        # astrocommunity.pack.bash
        bash-language-server
        shfmt
        shellcheck
        bashdb
        
        # astrocommunity.pack.fish
        fish
        
        # astrocommunity.pack.hyprland
        hyprls
        
        # astrocommunity.pack.markdown
        marksman
        prettierd
      ];
    };

    # Smart nvim config activation:
    # - If nvim config doesn't exist, copy from flake
    # - If nvim config exists, skip
    # Therefore, config is fully mutable
    home.activation.nvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d /home/${config.primaryUser}/.config/nvim ]; then
        echo "No nvim config found, copying from flake..."
        mkdir -p /home/${config.primaryUser}/.config/nvim
        cp -r ${astronvim-dotfiles}/* /home/${config.primaryUser}/.config/nvim/
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
