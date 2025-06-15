{ config, lib, pkgs, ... }:

let
  # Fetch AstroNvim dotfiles
  astroNvim = builtins.fetchGit {
    url = "https://github.com/ButterSus/astronvim-dotfiles.git";
    rev = "bf36a1664dfb05555901eb8351f8d4c9f1cb64ec";
  };
  nvimFiles = builtins.attrNames (builtins.readDir astroNvim);
  nvimDotfiles = builtins.listToAttrs (map (name: {
    name = ".config/nvim/${name}";
    value = { source = "${astroNvim}/${name}"; };
  }) nvimFiles);
in {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    lazygit
    ripgrep
    python3
    bottom
    lua
    gnumake
    clang
    fd
    git
    luarocks
  ];
  # Symlink all files from AstroNvim
  home.file = nvimDotfiles;
}
