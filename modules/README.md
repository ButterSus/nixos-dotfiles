# Working with Modules

## What Are Modules?

Modules organize related settings into reusable components that work with both NixOS and Home Manager.

```
$ tree modules/ -L 2
modules/
├── git/
│   ├── home.nix
│   └── nixos.nix
├── nvim/
│   └── home.nix
├── system/
│   └── nixos.nix
└── template/
    ├── home.nix
    └── nixos.nix
```

## How to Use Modules

Enable and configure modules in your host's `configuration.nix`:

```nix
{
  primaryUser = "username";
  
  # Enable modules with default settings
  modules.nvim.enable = true;
  
  # Configure module options
  modules.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "email@example.com";
  };
}
```

## Create a New Module

1. **Copy Template**
   ```bash
   mkdir -p modules/my-module
   cp modules/template/home.nix modules/my-module/
   ```

2. **Edit Module**
   ```nix
   # modules/my-module/home.nix
   { config, pkgs, lib, ... }: let
     cfg = config.modules.my-module;
   in {
     # Define options
     options.modules.my-module = {
       enable = lib.mkEnableOption "my-module";
       # Add other options as needed
     };
     
     # Apply configuration when enabled
     config = lib.mkIf cfg.enable {
       home.packages = [ pkgs.my-package ];
       # Other configuration...
     };
   }
   ```

3. **Use Your Module**
   It's automatically detected - just enable it in your host's configuration.nix:
   ```nix
   modules.my-module.enable = true;
   ```

Module files are automatically imported by `flake.nix` - no manual imports needed.
