{
  description = "Minimal Modular NixOS Configuration";

  # System inputs
  inputs = {
    # Core package sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # System outputs (configurations)
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      
      # Auto-import all modules from the modules directory
      importModules = modulesPath:
        let
          # Get all entries in the modules directory
          entries = builtins.readDir modulesPath;
          
          # Filter directories only (potential modules)
          moduleDirs = lib.filterAttrs (name: type: type == "directory" && name != "template") entries;
          
          # Create a list of module paths
          modulePaths = lib.mapAttrsToList
            (name: _: modulesPath + "/${name}")
            moduleDirs;
        in
          modulePaths;
      
      # Function to create system configurations
      mkSystem = { system, hostname }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; };
          modules = 
            # Auto-imported modules
            (importModules ./modules) ++
            
            [
              # Host-specific hardware configuration
              (./hosts + "/${hostname}/hardware-configuration.nix")
              
              # Host-specific configuration
              (./hosts + "/${hostname}/configuration.nix")
              
              # Home Manager configuration
              home-manager.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs hostname; };
                };
              }
            ];
        };
    in {
      # NixOS configurations
      nixosConfigurations = {
        # Gaming laptop configuration
        gaming-laptop = mkSystem {
          system = "x86_64-linux";
          hostname = "gaming-laptop";
        };
      };
    };
}
