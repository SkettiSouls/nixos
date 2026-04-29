{
  flake.modules.nixos.steam =
    { config, lib, pkgs, ... }:
    let
      cfg = config.programs.steam;
      mkEnabledOption = desc: lib.mkEnableOption desc // { default = true; };
    in {
      options.programs.steam = {
        hardware.enable = mkEnabledOption "Steam hardware (Steam Controller, HTC Vice, etc)";
        proton-ge = {
          enable = mkEnabledOption "Include proton-ge";
          package = lib.mkPackageOption pkgs "proton-ge-bin" {};
        };
      };

      config = {
        hardware.steam-hardware.enable = lib.mkDefault cfg.hardware.enable;
        programs = {
          gamemode.enable = lib.mkDefault true;

          steam = {
            enable = true;
            protontricks.enable = lib.mkDefault true;
            extraCompatPackages = lib.optionals cfg.proton-ge.enable [
              (cfg.proton-ge.package.override (p: { steamDisplayName = p.version; }))
            ];
          };
        };
      };
    };
}
