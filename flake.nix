{
  description = "Minimal Modular NixOS Configuration";

  inputs = {
    # Main NixOS flake
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Overlays
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Additional flake inputs (no need to specify these in parameters)
    astronvim-dotfiles = {
      url = "github:ButterSus/astronvim-dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
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
        { nixpkgs.overlays = overlays; }
        (./hosts + "/${hostname}/home.nix")
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
