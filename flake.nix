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
      
      # Function to create system configurations
      mkSystem = { 
        system,
        hostname, 
        username ? "buttersus"
      }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs hostname username; 
          };
          modules = [
            # Common system configuration
            ./modules/system
            
            # Host-specific hardware configuration
            (./hosts + "/${hostname}/hardware-configuration.nix")
            
            # Host-specific configuration
            (./hosts + "/${hostname}/configuration.nix")
            
            # Home Manager configuration
            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs hostname username; };
                users.${username} = { ... }: {
                  imports = [ ./modules/home ];
                };
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
