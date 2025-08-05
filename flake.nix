{
  description = "Minimal Modular NixOS Configuration";
  
  inputs = {
    ## Main NixOS flakes

    # This is used for 90% system packages, needs
    # to be updated every few months
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # This input can be updated whenever you want,
    # it's used for proprietary software that requires the
    # most recent version (e.g. windsurf)
    nixpkgs-recent.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Secret provisioning
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ## Overlays
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Maybe, soon, I'll consider using stylix.
    
    ## Additional flake inputs (no need to specify these in parameters)
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";    

    sddm-astronaut-theme = {
      url = "github:Keyitdev/sddm-astronaut-theme";
      flake = false;
    };
    
    catppuccin-discord = {
      url = "github:catppuccin/discord";
      flake = false;
    };
    
    catppuccin-qt5ct = {
      url = "github:catppuccin/qt5ct";
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

    textfox = {
      url = "github:ButterSus/textfox";
      inputs.nur.follows = "nur";
    };
  };

  outputs = { nixpkgs, nixpkgs-recent, home-manager, ... }@inputs: let
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
      specialArgs = { 
        inherit inputs hostname;
        pkgs-recent = import nixpkgs-recent {
          inherit system;
          overlays = overlays;
          config.allowUnfree = true;
        };
        isHMStandaloneContext = false;
      };
      modules = importModules ./modules "nixos" ++ [
        # Home Manager module configuration
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
          };
        }

        # Per-host configuration
        (./hosts + "/${hostname}/hardware-configuration.nix")
        (./hosts + "/${hostname}/configuration.nix")

        # Overlays
        { nixpkgs.overlays = overlays; }
        
        # NixOS modules
        inputs.catppuccin.nixosModules.catppuccin
        inputs.sops-nix.nixosModules.sops
        inputs.minegrub-world-sel-theme.nixosModules.default

        # Home Manager shared modules
        {
          home-manager.sharedModules = [
            inputs.catppuccin.homeModules.catppuccin
            inputs.sops-nix.homeManagerModules.sops
            inputs.textfox.homeManagerModules.default
          ];
          
          modules.sops.defaultSopsFile = ./secrets/default.yaml;
          
          # Allow non-free packages
          nixpkgs.config.allowUnfree = true;
        }
      ]
      
      # Host-specific NixOS configuration (if exists)
      ++ lib.optional (builtins.pathExists (./hosts + "/${hostname}/nixos.nix"))
          (./hosts + "/${hostname}/nixos.nix");
    };

    mkHomeConfiguration = { system, hostname }: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { 
        inherit inputs hostname;
        isHMStandaloneContext = true;
        pkgs-recent = import nixpkgs-recent {
          inherit system;
          overlays = overlays;
          config.allowUnfree = true;
        };
      };
      modules = importModules ./modules "home" ++ [
        # Per-host configuration
        (./hosts + "/${hostname}/configuration.nix")

        # Overlays
        { nixpkgs.overlays = overlays; }
        
        # Home Manager modules
        {
          imports = [
            inputs.catppuccin.homeModules.catppuccin
            inputs.sops-nix.homeManagerModules.sops
            inputs.textfox.homeManagerModules.default
          ];
          
          modules.sops.defaultSopsFile = ./secrets/default.yaml;
          
          # Allow non-free packages
          nixpkgs.config.allowUnfree = true;
        }
      ]
      
      # Host-specific Home Manager configuration (if exists)
      ++ lib.optional (builtins.pathExists (./hosts + "/${hostname}/home.nix"))
          (./hosts + "/${hostname}/home.nix");
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
