perSystem@{ config }:
nixos@{ config, lib, inputs, self, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.users.users;
in
{
  options.users.users = mkOption {
    type = with types; attrsOf (submodule {
      options.wrapper-manager = {
        enable = mkEnableOption "Manage user configs with wrapper-manager";

        packages = mkOption {
          type = with types; listOf package;
          default = [];
        };

        installAll = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to install all wrapped packages.

            When this option is enabled packages are installed by simplying placing
            the module in the imports of `userModules.<user>.wrapper-manager`.
          '';
        };
      };
    });
  };

  config = {
    users.users = lib.mapAttrs (u: _: {
      packages = let
        wm = cfg.${u}.wrapper-manager;
      in if wm.enable && wm.installAll then
        (builtins.attrValues perSystem.config.wrappedPackages.${u})
      else
        wm.packages;
    }) nixos.config.flake.userModules;
  };
}
