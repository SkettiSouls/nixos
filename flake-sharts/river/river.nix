{ config, lib, pkgs, ... }:
let
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

  # Works because layout.generator is type `oneOf [ "rivertile" path package ]`
  isPackage = x: if (isPath x) || (isString x) then false else true;
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
                if isAttrs option then filterAttrs (n: v: v != null) option else option
              ) value.byTitle;
            } else if isAttrs value then filterAttrs (n: v: v != null) value else value)
          cfg.rules.byId);

          "-title" = mkIf (cfg.rules.byTitle != null) (mapAttrs (id: value:
              if (isAttrs value) && (value.byId != null) then {
                "-app-id" = mapAttrs (id: option:
                  if isAttrs option then filterAttrs (n: v: v != null) option else option
                ) value.byId;
              } else if isAttrs value then filterAttrs (n: v: v != null) value else value)
            cfg.rules.byTitle);
        });

        spawn = cfg.startup.apps;
      };
    };
  };
}
