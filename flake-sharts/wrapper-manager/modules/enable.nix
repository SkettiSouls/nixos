perSystem@{ config }:
nixos@{ config, lib, inputs, self, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.users.users;
in
{
  options.users.users = mkOption {
    type = with types; attrsOf (submodule {
      options.wrapper-manager.enable = mkEnableOption "Manage user configs with wrapper-manager";
    });
  };

  config = {
    users.users = lib.mapAttrs (u: _: {
      packages = mkIf cfg.${u}.wrapper-manager.enable
        (builtins.attrValues perSystem.config.wrappedPackages.${u});
    }) nixos.config.flake.userModules;
  };
}
