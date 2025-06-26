{ inputs, ... }:
{ pkgs, ... }:
let
  plpPkgs = inputs.polyphasia.packages.${pkgs.system};

  sleep = {
    script = "${./sleep.lua}";
    cores = with builtins;
      pkgs.writeText "cores.json" (toJSON [
        {
          start = 23.5;
          end = 1.5;
        }
        {
          start = 7.5;
          end = 9.0;
        }
        {
          start = 16.0;
          end = 17.5;
        }
      ]);
  };
in
{
  wrappers.polyphasia = {
    basePackage = plpPkgs.polyphasia.overrideAttrs (prev: {
      passthru = { inherit sleep; };
    });

    extraPackages = [ plpPkgs.plp-fetch ];
    pathAdd = [ pkgs.gammastep ];

    programs = {
      plp-fetch.prependFlags = [ "-c" sleep.cores ];
      polyphasia = {
        env.PLP_WLCOMPOSITOR.value = "niri";
        prependFlags = [ "${pkgs.lua}/bin/lua ${sleep.script}" sleep.cores "--padding" "2" ];
      };
    };
  };
}
