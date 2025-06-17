# My NixOS & Home Manager Configs

<p align="center">
  <img src="./pics/kaboom.png" height="200"/>
</p>

These are my personal NixOS and Home Manager dotfiles, built with Flakes.

## Key Things

*   **Modular:** Settings are split into modules for easier management.
*   **Auto-Discovers Hosts:** New machines/profiles in `hosts/` are picked up automatically.
*   **Per-Host System Arch:** Each host specifies its architecture (e.g., `x86_64-linux`) in `hosts/your-hostname/system.nix`.
*   **Dual Mode:** Works for full NixOS setups (with Home Manager) or standalone Home Manager.

## How to Apply

1.  **NixOS System (includes Home Manager):**
    ```bash
    sudo nixos-rebuild switch --flake .#hostname
    ```
    *(Replace `hostname` with yours, e.g., `gaming-laptop`)*

2.  **Standalone Home Manager:**
    (For just user configs, e.g., on non-NixOS or a separately managed user)
    ```bash
    home-manager switch --flake .#hostname
    ```
    *(Replace `hostname` with yours, e.g., `gaming-laptop`)*

## Adding a New Machine/Profile

See the [guide in the hosts directory](./hosts/README.md).

## Quick Dev Tip: Untracked Files

Nix flakes ignore untracked files by default. If you're testing changes that aren't staged in Git yet, use the `--impure` flag:

```bash
sudo nixos-rebuild switch --flake .#hostname --impure
# or for Home Manager:
home-manager switch --flake .#hostname --impure
```
Don't forget to `git add` and commit your changes when they're ready!
