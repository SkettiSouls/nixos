{ user, ... }:
{ inputs, self, config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.wrapper-manager;
in
{
  options.wrapper-manager = {
    enable = mkEnableOption "Wrapper manager";

    packages = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    users.users.${user}.packages = [
      (inputs.wrapper-manager.lib.build {
        inherit pkgs;
        specialArgs = { inherit inputs self; };
        modules = cfg.packages;
      })
    ];
  };
}
