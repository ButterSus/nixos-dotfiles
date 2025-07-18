# Adding a New Host

The `flake.nix` automatically finds new hosts added here.

## Quick Steps

1. **Create Host Directory**
   ```bash
   mkdir -p hosts/my-host
   ```

2. **Define Architecture**
   Create `system.nix` with just the architecture string:
   ```nix
   # hosts/my-host/system.nix
   "x86_64-linux"  # or "aarch64-linux" for ARM
   ```

3. **Create Configuration**
   ```nix
   # hosts/my-host/configuration.nix
   { config, pkgs, lib, ... }:

   {
     primaryUser = "your-username";  # Important!

     # System settings
     modules.system = {
       enable = true;
       hostName = "my-hostname";
       timeZone = "Your/Timezone";
       locale = "en_US.UTF-8";
       stateVersion = "24.11";
     };

     # User settings
     modules.home = {
       enable = true;
       enableCli = true;
       stateVersion = "24.11";
     };

     # Enable modules you need
     # modules.git.enable = true;
     # modules.nvim.enable = true;
   }
   ```

4. **Add Hardware Configuration**
   For NixOS systems, copy from your existing install:
   ```bash
   cp /etc/nixos/hardware-configuration.nix hosts/my-host/
   ```

5. **Apply Configuration**
   ```bash
   # Full NixOS
   sudo nixos-rebuild switch --flake .#my-host

   # Standalone Home Manager
   home-manager switch --flake .#my-host
   ```

## Optional Host-Specific Files

You can also create these files for host-specific customizations:

- **nixos.nix**: For system-level settings outside the module system
  ```nix
  # hosts/my-host/nixos.nix
  { config, lib, pkgs, ... }:
  {
    # Direct NixOS configurations
    # Add packages, services, or configurations
    # that don't fit into the module system
    environment.systemPackages = with pkgs; [
      htop
      git
    ];
  }
  ```

- **home.nix**: For user-level settings outside the module system
  ```nix
  # hosts/my-host/home.nix
  { config, lib, pkgs, ... }:
  {
    # Direct Home Manager configurations
    # for when you don't want to create a module
    home.packages = with pkgs; [
      firefox
      vscode
    ];
  }
  ```

## Best Practices
- Use modules from `../modules/` for most settings
- See [Modules README](../modules/README.md) for details
