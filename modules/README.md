# Working with Modules

This Nix Flake configuration is heavily based on a modular design. Modules help keep settings organized, reusable, and easier to manage across different hosts and profiles.

## What are Modules?

In this setup, a module is typically a directory within this `modules/` folder (e.g., `modules/git/`, `modules/neovim/`). Each module directory contains Nix files that define a set of related options, packages, and configurations for a specific application, service, or aspect of the system/user environment.

Key characteristics:

*   **Self-Contained:** A module should ideally manage all the necessary settings for what it configures.
*   **Reusable:** Designed to be enabled and configured on any host.
*   **Dual Compatibility:** Modules here are written to be compatible with both:
    *   NixOS system configurations (imported via `flake.nix` into `mkSystem`)
    *   Standalone Home Manager configurations (imported via `flake.nix` into `mkHomeConfiguration`)

## Module Structure

A typical module directory (e.g., `modules/example/`) might contain:

*   `default.nix` or `home.nix` or `nixos.nix`: The main Nix file that defines the module's options and configuration logic. Often, you'll see `home.nix` for settings primarily managed by Home Manager and `nixos.nix` for system-level NixOS settings. The `flake.nix` is set up to automatically import a `home.nix` file for Home Manager contexts and a `nixos.nix` file for NixOS contexts from each module directory.
*   Supporting `.nix` files: For more complex modules, you might split configuration into multiple files within the module's directory and import them into the main module file.
*   Static configuration files: E.g., `config/example.conf` that the module might link into the appropriate XDG config directory.

## How Modules are Imported

The main `flake.nix` contains a helper function `importModules`. This function automatically scans this `modules/` directory:

*   For NixOS configurations (via `mkSystem`), it looks for and imports `modules/<module_name>/nixos.nix` from each module folder.
*   For Home Manager configurations (via `mkHomeConfiguration`), it looks for and imports `modules/<module_name>/home.nix` from each module folder.

This means you don't need to manually add each module to the `flake.nix` imports list. Just creating the directory and the relevant `nixos.nix` or `home.nix` file is enough for it to be picked up.

## Enabling and Configuring Modules

Modules are typically enabled and configured within each host's `home.nix` file (for user/Home Manager settings) or sometimes `configuration.nix` (for system-level settings if the module exposes NixOS options).

For example, in `hosts/my-pc/home.nix`:

```nix
{
  # ... other host settings ...

  modules.git = {
    enable = true;
    userName = "My Name";
    userEmail = "my.email@example.com";
  };

  modules.neovim.enable = true;

  # ... etc ...
}
```

Each module should define its own options (like `enable`, `userName` in the `git` example). You'll need to refer to the specific module's Nix file(s) to see what options it provides.

## Creating a New Module

1.  **Copy the Template:**
    The easiest way to start a new module is to copy the `template/` directory located within this `modules/` folder. Rename the copied directory to match your new module's name (e.g., `modules/my-new-app/`).
    ```bash
    cp -r modules/template/ modules/my-new-app
    ```

2.  **Customize Template Files:**
    Inside your new module directory (e.g., `modules/my-new-app/`):
    *   Edit `home.nix` for Home Manager specific configurations.
    *   Edit `nixos.nix` for NixOS system-level configurations.
    *   You can delete either `home.nix` or `nixos.nix` if your module only targets one type of configuration.

3.  **Define Options and Configuration (in `home.nix`/`nixos.nix`):**
    The template files provide a basic structure. You'll need to:
    *   **Update Option Paths:** Change `options.modules.template` to `options.modules.my-new-app` (or whatever your module is named).
    *   **Adjust `cfg` Variable:** Ensure the `cfg` variable correctly points to your module's configuration (e.g., `cfg = config.modules.my-new-app;`).
    *   **Define Your Options:** Add or modify options using `lib.mkOption` for things like `enable`, custom settings, package lists, etc.
    *   **Implement Configuration Logic:** Use `config = lib.mkIf cfg.enable { ... };` to apply settings when the module is enabled.

    Refer to the comments within the template files (`template/home.nix` and `template/nixos.nix`) for more detailed guidance on where to make changes.

    Example snippet from a customized `modules/my-new-app/home.nix`:
    ```nix
    {
      config,
      pkgs,
      lib,
      ... 
    }: let
      # Adjust this path to match your module's location in the config
      cfg = config.modules.my-new-app; 
    in {
      # Adjust this path for your module's options
      options.modules.my-new-app = {
        enable = lib.mkEnableOption "my-new-app"; # Creates a simple enable flag
        someSetting = lib.mkOption {
          type = lib.types.str;
          default = "default value";
          description = "An example string setting for my-new-app.";
        };
        # Add more options here
      };

      config = lib.mkIf cfg.enable { # This block is applied if cfg.enable is true
        home.packages = [ pkgs.some-package-for-my-new-app ];
        # Add other Home Manager configurations
      };
    }
    ```

4.  **Enable and Configure on a Host:**
    Go to a host's `home.nix` (e.g., `hosts/my-pc/home.nix`) and enable/configure your new module:
    ```nix
    {
      # ... other host configurations ...

      modules.my-new-app = {
        enable = true;
        someSetting = "custom value for this host";
      };
    }
    ```


## Modifying Existing Modules

Simply edit the Nix files within the respective module's directory. You can add new options, change default values, or alter the configurations they apply.

By following this modular approach, you can build a powerful and maintainable Nix configuration tailored to your needs.
