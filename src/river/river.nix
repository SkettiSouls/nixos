{ self, config, lib, pkgs, ... }:
let
  inherit (self.lib) exponent;
  inherit (lib)
    filterAttrs
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
  mkTag = tag: toString (exponent 2 (tag - 1));
  cfg = config.regolith.river;
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
      extraConfig = cfg.extraConfig;

      settings = recursiveUpdate cfg.settings {
        background-color = mkDefault "0x002b36";
        border-color-focused = mkDefault "0x93a1a1";
        border-color-unfocused = mkDefault "0x586e75";
        default-layout = mkDefault (if (isPackage generator) then "${generator}/bin/*" else "${generator}");
        set-repeat = mkDefault "50 300";

        declare-mode = cfg.modes;

        rule-add = let
          checkForTags = value:
            (if (value.tags != null) && (value.output != null) then { tags = mkTag value.tags; output = mkTag value.output; } else
            (if (value.tags != null) then { tags = mkTag value.tags; } else
            (if (value.output != null) then { output = mkTag value.output; } else {})));

          rmNull = x: filterAttrs (n: v: v != null) x;

          # Fix rules that lack args
          handleRules = attrs: (rmNull attrs) // checkForTags attrs // {
            csd = mkIf (attrs.csd == true) "";
            ssd = mkIf (attrs.ssd == true) "";
            float = mkIf (attrs.float == true) "";
            no-float = mkIf (attrs.float == false) "";
            fullscreen = mkIf (attrs.fullscreen == true) "";
            no-fullscreen = mkIf (attrs.fullscreen == false) "";
          };
        in
        (recursiveUpdate cfg.rules.extraConfig {
          # Updating with `idRules` and `titleRules` allows for both nested (i.e `byTitle`) and top level rules.
          # For example:
          # ```
          # rules.byId.steam.ssd = true;
          # rules.byId.steam.byTitle."Launching...".float = true;
          # ```

          "-app-id" = mkIf (cfg.rules.byId != null) (mapAttrs (id: attrs:
            if attrs.byTitle != null then
            let
              idRules = filterAttrs (n: v: n != "byTitle") attrs;
            in
            {
              "-title" = mapAttrs (_: option:
                handleRules option
              ) attrs.byTitle;
            } // handleRules idRules else handleRules attrs)
          cfg.rules.byId);

          "-title" = mkIf (cfg.rules.byTitle != null) (mapAttrs (id: attrs:
          if attrs.byId != null then
          let
            titleRules = filterAttrs (n: v: n != "byId") attrs;
          in
          {
            "-app-id" = mapAttrs (_: option:
              handleRules option
            ) attrs.byId;
          } // handleRules titleRules else handleRules attrs)
          cfg.rules.byTitle);
        });

        spawn = map (cmd: "'${cmd}'") cfg.startup.apps;
      };
    };
  };
}
