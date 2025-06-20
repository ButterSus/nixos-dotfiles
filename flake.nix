{
  description = "Minimal Modular NixOS Configuration";
  
  inputs = {
    # Main NixOS flake
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Overlays
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Maybe, soon, I'll consider using stylix.
    
    # Additional flake inputs (no need to specify these in parameters)
    astronvim-dotfiles = {
      url = "github:ButterSus/astronvim-dotfiles";
      flake = false;
    };
    
    sddm-astronaut-theme = {
      url = "github:Keyitdev/sddm-astronaut-theme";
      flake = false;
    };
    
    hyprland = {  # Use latest hyprland version to use most recent plugins
      type = "git";
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";  # Don't duplicate
    };
  };

  outputs = { nixpkgs, catppuccin, home-manager, ... }@inputs: let
    lib = nixpkgs.lib;
    
    overlays = with inputs; [
      nur.overlays.default
    ];

    importModules = modulesPath: filename: let
      entries = builtins.readDir modulesPath;
      moduleDirs = lib.filterAttrs (name: type: type == "directory" && name != "template") entries;
      modulePaths = lib.mapAttrsToList (name: _: "${modulesPath}/${name}/${filename}.nix") moduleDirs;
    in modulePaths;

    mkSystem = { system, hostname }: lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostname; isHMStandaloneContext = false; };
      modules = (importModules ./modules "nixos") ++ [
        (./hosts + "/${hostname}/hardware-configuration.nix")
        (./hosts + "/${hostname}/configuration.nix")
        { nixpkgs.overlays = overlays; }
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
          };
        }
      ];
    };

    mkHomeConfiguration = { system, hostname }: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs hostname; isHMStandaloneContext = true; };
      modules = (importModules ./modules "home") ++ [
        (./hosts + "/${hostname}/home.nix")
        { nixpkgs.overlays = overlays; }
      ];
    };

    findHosts = path: lib.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir path));
    hosts = findHosts ./hosts;

  in {
    nixosConfigurations = lib.genAttrs hosts (host: mkSystem {
      system = import (./hosts + "/${host}/system.nix");
      hostname = host;
    });

    homeConfigurations = lib.genAttrs hosts (host: mkHomeConfiguration {
      system = import (./hosts + "/${host}/system.nix");
      hostname = host;
    });
  };
}
