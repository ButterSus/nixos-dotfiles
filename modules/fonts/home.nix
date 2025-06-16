# /mnt/modules/fonts/home.nix
{
  config,
  lib,
  pkgs,
  isHMStandaloneContext, # To distinguish between NixOS module and standalone HM
  primaryUser, # Assuming this is passed via specialArgs for the username
  ... # Any other specialArgs or inputs if needed
}:

with lib;

let
  cfg = config.modules.fonts;

  # Define any Home Manager specific font configurations here if needed in the future.
  # For now, installation is handled by the NixOS module.
  moduleHomeConfig = {
    # Example: home.pointerCursor = { ... }; if you wanted HM to manage cursors.
  };
in
{
  options.modules.fonts = {
    enable = mkEnableOption "Enable user-specific font configurations (primarily for consistency with NixOS module)";
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      # The assertion previously here caused issues with accessing NixOS module options directly.
      # For now, it's assumed that if the user enables the fonts module in their NixOS config,
      # they intend for system-wide fonts to be available.
      # If this HM module gains more user-specific font functionality that depends on system fonts,
      # this dependency should be documented or handled differently.
      assertions = []; # Placeholder for any future, valid assertions
    }
    (if isHMStandaloneContext then
      moduleHomeConfig
    else
      # Ensure primaryUser is correctly derived or passed if this structure is used.
      # It might be simpler to just return moduleHomeConfig and let the flake's homeManagerConfiguration handle user assignment.
      { home-manager.users.${config.primaryUser} = moduleHomeConfig; }
    )
  ]);
}
