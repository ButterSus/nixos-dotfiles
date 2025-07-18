# My NixOS & Home Manager Configs

<p align="center">
  <img src="./pics/kaboom.png" height="200"/>
</p>

Personal NixOS and Home Manager dotfiles with Flakes.

## Key Features

* **Modular:** Settings split into modules
* **Auto-Discovers Hosts:** New machines in `hosts/` detected automatically
* **Per-Host System Arch:** Each host specifies architecture in `hosts/hostname/system.nix`
* **Dual Mode:** Works for full NixOS or standalone Home Manager

## Quick Start

```bash
# Full NixOS + Home Manager
sudo nixos-rebuild switch --flake .#hostname

# Standalone Home Manager
home-manager switch --flake .#hostname
```

## Notes

- Uses catppuccin theme (not configurable)
- Current state version: 24.11
- See [hosts/README.md](./hosts/README.md) for adding machines
- See [modules/README.md](./modules/README.md) for module details
- **Linux Only:** Currently hardcoded for Linux with Unix paths, not compatible with macOS
- **Wayland Focus:** Primary testing done on Hyprland/Wayland; some modules may be Hyprland-specific
