{ self, config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  enableRole = role: { enable = mkIf (builtins.elem self.roles.${role} config.roles) true; };
in
{
  options.roles = mkOption {
    type = with types; listOf unspecified;
    default = [];
  };

  config.regolith.roles = lib.genAttrs [
    "desktop"
    "gaming"
    "server"
    "workstation"
  ] (role: enableRole role);
}
