# NixOS Configuration

<p align="center">
  <img src="./pics/kaboom.png" height="200"/>
</p>

Personal NixOS and Home Manager configurations using Flakes.

## Usage

```bash
# NixOS rebuild
sudo nixos-rebuild switch --flake .#hostname

# Home Manager only
home-manager switch --flake .#hostname
```

## Structure

```
$ tree -L 1
.
├── flake.lock
├── flake.nix       # Main configuration entry point
├── hosts/          # Host-specific configurations
├── modules/        # Reusable configuration modules
├── pics/           # Images
└── secrets/        # Encrypted secrets (sops-nix)
```

## Notes

- Uses catppuccin theme
- Current state version: 24.11
- Linux-only implementation with Unix paths
- Primarily tested with Hyprland/Wayland
- Documentation: [hosts](./hosts/README.md), [modules](./modules/README.md)
