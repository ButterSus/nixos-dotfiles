# Git configuration module - fully declarative
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.git;
in {
  config = mkIf cfg.enable {
    # Home-manager Git configuration
    home-manager.users.${config.primaryUser} = { ... }: {
      programs.git = {
        enable = true;
        userName = cfg.userName;
        userEmail = cfg.userEmail;
        
        # Git config in declarative format
        extraConfig = {
          # Pull configuration
          pull.rebase = true;
          
          # Rebase configuration
          rebase.missingCommitsCheck = "error";
          
          # Merge configuration
          merge.conflictstyle = "zdiff3";
          
          # Push configuration
          push = {
            default = "simple";
            followTags = true;
          };
          
          # Branch default configuration
          init.defaultBranch = "main";
          
          # Commit configuration
          commit.verbose = true;
          
          # Auto conflict resolution
          rerere.enabled = true;
          
          # Core configuration
          core = {
            pager = "delta";
            editor = if config.modules.nvim.enable then "nvim" else "nano";
            autocrlf = "input";
            excludeFiles = "~/.config/git/ignore";
          };
          
          # Branch sort configuration
          branch.sort = "-committerdate";
          
          # GitHub pushing configuration
          "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";
          
          # Fetch configuration
          fetch.prune = true;
          
          # Log configuration
          log.date = "iso";
          
          # Mergetool configuration
          mergetool = {
            keepBackup = false;
            tool = if config.modules.nvim.enable then "nvim" else "nano";
          };
          
          # HTTP buffer size
          http.postBuffer = 1048576000;
          
          # Aliases
          alias = {
            save = "!git stash store \"$(git stash create)\"";
            graph = "log --graph --decorate --pretty=oneline --abbrev-commit";
          };
        };
        
        # Global gitignore settings
        ignores = [
          ".idea"
          "*.orig"
        ];
      };
      
      # Make sure git config directory exists
      home.file.".config/git/.keep".text = "";
    };
  };
}
