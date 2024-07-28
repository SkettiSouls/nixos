{ self, config, lib, pkgs, ... }:
let
  inherit (self.lib) exponent;
  inherit (lib)
    filterAttrs
    isAttrs
    isPath
    isString
    mapAttrs
    mkDefault
    mkIf
    recursiveUpdate
    ;

  inherit (cfg.layout) generator;

  checkForTags = value:
    (if (value.tags != null) && (value.output != null) then { tags = mkTag value.tags; output = mkTag value.output; } else
    (if (value.tags != null) then { tags = mkTag value.tags; } else
    (if (value.output != null) then { output = mkTag value.output; } else {})));


  # Works because layout.generator is type `oneOf [ "rivertile" path package ]`
  isPackage = x: if (isPath x) || (isString x) then false else true;
  rmNull = x: filterAttrs (n: v: v != null) x;
  mkTag = tag: toString (exponent 2 (tag - 1));
  cfg = config.shit.river;
in
{
  imports = [
    ./binds.nix
    ./options.nix
    ./rivertile.nix
  ];

  config = mkIf cfg.enable {
    home.packages = [
      (mkIf (isPackage generator) generator)
      (mkIf cfg.installTerminal pkgs.${cfg.variables.terminal})
    ];

    wayland.windowManager.river = {
      enable = true;
      package = cfg.package;
      xwayland.enable = true;

      settings = {
        background-color = mkDefault "0x002b36";
        border-color-focused = mkDefault "0x93a1a1";
        border-color-unfocused = mkDefault "0x586e75";
        default-layout = mkDefault (if (isPackage generator) then "${generator}/bin/*" else "${generator}");
        set-repeat = mkDefault "50 300";

        declare-mode = cfg.modes;

        rule-add = (recursiveUpdate cfg.rules.extraConfig {
          "-app-id" = mkIf (cfg.rules.byId != null) (mapAttrs (id: value:
            if (isAttrs value) && (value.byTitle != null) then {
              "-title" = mapAttrs (title: option:
                if isAttrs option then (rmNull option) // checkForTags option else option
              ) value.byTitle;
            } else if isAttrs value then (rmNull value) // checkForTags value else value)
          cfg.rules.byId);

          "-title" = mkIf (cfg.rules.byTitle != null) (mapAttrs (id: value:
              if (isAttrs value) && (value.byId != null) then {
                "-app-id" = mapAttrs (id: option:
                  if isAttrs option then (rmNull option) // checkForTags option else option
                ) value.byId;
              } else if isAttrs value then (rmNull value) // checkForTags value else value)
            cfg.rules.byTitle);
        });

        spawn = cfg.startup.apps;
      };
    };
  };
}
